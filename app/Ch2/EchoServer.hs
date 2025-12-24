{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Wai
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200, status500)
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Char8 as BS
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.Text.Encoding as TE
import System.IO (hFlush, stdout)

-- リクエストをダンプして表示する関数
-- Go の httputil.DumpRequest に相当
dumpRequest :: Request -> IO ()
dumpRequest req = do
    -- メソッド、パス、クエリ文字列を表示
    putStrLn $ BS.unpack (requestMethod req) ++ " "
            ++ BS.unpack (rawPathInfo req)
            ++ BS.unpack (rawQueryString req)
            ++ " " ++ show (httpVersion req)

    -- ヘッダーを表示
    mapM_ (\(name, value) ->
        BS.putStrLn $ name <> ": " <> value
        ) (requestHeaders req)

    -- 空行
    putStrLn ""

    -- ボディの読み込みと表示
    body <- strictRequestBody req
    BL.putStr body

    putStrLn "\n---"
    hFlush stdout

-- ハンドラー関数
-- Go の handler 関数に相当
handler :: Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
handler req respond = do
    -- リクエストをダンプ
    dumpRequest req

    -- HTMLレスポンスを返す
    respond $ responseLBS
        status200
        [("Content-Type", "text/html")]
        "<html><body>hello</body></html>\n"

-- メイン関数
main :: IO ()
main = do
    putStrLn "start http listening :18888"
    run 18888 handler
