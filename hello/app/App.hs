{-# LANGUAGE JavaScriptFFI, CPP, OverloadedStrings, ScopedTypeVariables #-}

module Main where

import Control.Monad
import Control.Concurrent
import GHCJS.Foreign
import GHCJS.Foreign.Callback
import GHCJS.Marshal
import GHCJS.Types
import GHCJS.Prim hiding (getProp)
import Data.JSString
import JavaScript.Cast
import Data.Maybe
import System.IO.Unsafe
import Data.String

{- Note. This isn't good Haskell code! It's atrocious. But that's not
what it's here for. This is a direct translation of the Hello World
example you get when you create a new project with
nativescript/tns. This includes the fact that in the project there's a
split between main_view_model and main_page (they live in separate .js
files). There's no reason to do this aside from a pedagocial one: this
will be necessary when we really do have multiple views with more
complex apps. So we keep that setup here in order to show how those
mechanisms work. -}

{- The control flow here can be a bit confusing. First nativescript
starts up app.js (the result of compiling this code). This runs main,
and main must run synchronously and eventually return back to ns. Main
exports functions which have the same names as the views (this app has
only one view, main-page). main-page is the Main action, so it gets
displayed and that code is run. That file (and all other .js files)
contain stubs that look like:

  require("./app.js")["main-page"](module.exports);

In our case the function main_page is exported as
main-page. Javascript starts the main-page view and calls back into
Haskell. We export a pageLoaded callback which, by way of another
level of identical callbacks and direction to get main-view-mode, sets
the model-view-mode as the bindingContext of the page. This provides
us with an observable that receives callbacks when changes occur. -}

foreign import javascript unsafe "$1.start()"
  start :: (JSRef a) -> IO ()

-- We really want this:
--
--   foreign import javascript unsafe "$1.require($2)"
--     require :: (JSRef a) -> JSString -> IO (JSRef a)
--
-- but unfortunately nativescript doesn't support this require
-- syntax. Seems like it's node.js specific. This means we end up
-- requiring everything into the current module.

foreign import javascript unsafe "require($1)"
  require :: JSString -> IO (JSRef a)

foreign import javascript unsafe "$1[$2] = $3"
  export' :: (JSRef a) -> JSString -> JSRef a -> IO ()
foreign import javascript unsafe "$1[$2] = $3"
  js_export :: (JSRef a) -> JSString -> Callback (IO ()) -> IO ()
foreign import javascript unsafe "$1[$2] = $3"
  js_export1 :: (JSRef a) -> JSString -> Callback (b -> IO ()) -> IO ()

export mod name f = syncCallback ThrowWouldBlock f >>= js_export mod name
export1 mod name f = syncCallback1 ThrowWouldBlock f >>= js_export1 mod name

foreign import javascript unsafe "$1[$2] = $3"
  setProp :: JSRef a -> JSString -> JSRef b -> IO (JSRef c)

foreign import javascript unsafe "$1[$2]"
  getProp :: JSRef a -> JSString -> IO (JSRef b)

foreign import javascript unsafe "$r = exports"
  js_exports :: JSRef a

-- TODO Why do we need a temporary here? I don't understand why this
-- doesn't work without it.
foreign import javascript unsafe "obs = require('data/observable'); $r = new obs.Observable()"
  newObservable :: IO (JSRef a)

foreign import javascript unsafe "$1.set($2, $3);"
  o_set :: JSRef a -> JSRef b -> JSRef c -> IO ()

set_message o s = o_set o (sToRef "message") =<< s

foreign import javascript unsafe "$1[$2] = $1[$2] - 1"
  dec :: JSRef a -> JSString -> IO ()
foreign import javascript unsafe "$1[$2] = $1[$2] + 1"
  inc :: JSRef a -> JSString -> IO ()

main_view_model e = do
  model <- newObservable
  setProp model "counter" =<< toJSRef (5 :: Int)
  let taps = do Just (d::Int) <- fromJSRef =<< getProp model "counter"
                return $ sToRef $ show d ++ " taps left"
  set_message model taps
  setProp model "tapAction"
    =<< toJSRef =<< syncCallback ThrowWouldBlock (do
                                        dec model "counter"
                                        Just (d::Int) <- fromJSRef =<< getProp model "counter"
                                        if d <= 0 then
                                          set_message model $ return $ sToRef "Unlocked" 
                                          else
                                          set_message model taps
                                        return ())
  export' e "mainViewModel" model
  return ()

-- Convention is underscores in the name of what would be js modules
-- but dashes when exporting. js doesn't have functions with
-- dashes so we won't clash.

main_page e = do
  view <- require "./main-view-model"
  export1 e "pageLoaded"
    (\a -> do
         page <- getProp a "object"
         setProp page "bindingContext" =<< getProp view "mainViewModel"
         return ())

sToRef :: String -> JSRef String
sToRef x = unsafePerformIO $ toJSRef x

main = do
 app <- require "application"
 setProp app "mainModule" $ sToRef "main-page"
 setProp app "cssFile" $ sToRef "./app.css"
 export1 js_exports "main-page" main_page
 export1 js_exports "main-view-model" main_view_model
 start app
 return ()
