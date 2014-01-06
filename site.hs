-- Source file for katychuang.com
-- Author: Katherine Chuang @katychuang



-------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Monad (forM_, zipWithM_, liftM)
import           Data.Monoid (mappend, mconcat)
import           Hakyll
import           Text.Pandoc (writerReferenceLinks)
import           Data.Char (toLower)
import           System.Locale (defaultTimeLocale)
import           Data.List (sortBy, intercalate)
import           Data.Time.Clock (UTCTime)
import           System.FilePath (takeBaseName, takeFileName)
import           Data.Time.Format (parseTime)
import           Data.List (isPrefixOf, tails, findIndex)

import           Text.Blaze.Html.Renderer.String (renderHtml)
import           Text.Blaze.Internal (preEscapedString)
import           Text.Blaze.Html ((!), toHtml, toValue)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

-- Allow for reference style links in markdown
pandocWriteOptions = defaultHakyllWriterOptions
    { writerReferenceLinks = True
    }

-------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do

    match "templates/*" $ compile templateCompiler

    match "favicon.ico" $ do
        route   idRoute
        compile copyFileCompiler

    match "images/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/**" $ do
        route   idRoute
        compile compressCssCompiler

    tags <- buildTags "posts/*" (fromCapture "label/*")

    -- Match all files under posts directory and its subdirectories.
    -- Turn posts into permalinked style url: year/month/title/index.html
    forM_ [("posts/*", "templates/post.html", "templates/postfooter.html"),
           ("pages/*", "templates/page.html", "templates/pagefooter.html"),
           ("products/*", "templates/page.html", "templates/pagefooter.html")] $ \(p, t, f) ->
        match p $ do
            route $ permalinkedRoute
            compile $ do
                let allCtx =
                        field "recent" (\_ -> recentPostList) `mappend`
                        defaultContext

                pandocCompilerWith defaultHakyllReaderOptions pandocWriteOptions
                    >>= saveSnapshot "teaser"
                    >>= loadAndApplyTemplate t (postCtx tags)
                    >>= saveSnapshot "content"
                    >>= loadAndApplyTemplate f (postCtx tags)
                    >>= loadAndApplyTemplate "templates/default.html" allCtx
                    >>= permalinkedifyUrls

    -- Build special pages
    forM_ ["index.markdown", "404.markdown", "search.markdown"] $ \p ->
        match p $ do
            route   $ setExtension "html"
            compile $ do
                let allCtx =
                        field "recent" (\_ -> recentPostList) `mappend`
                        defaultContext

                pandocCompilerWith defaultHakyllReaderOptions pandocWriteOptions
                    >>= loadAndApplyTemplate "templates/page.html" (postCtx tags)
                    >>= loadAndApplyTemplate "templates/default.html" allCtx
                    >>= permalinkedifyUrls

    -- Labels
    tagsRules tags $ \tag pattern -> do
        let title = "Articles filed under " ++ " &#8216;" ++ tag ++ "&#8217;"
        route labelRoute
        compile $ do
            let allCtx =
                    field "recent" (\_ -> recentPostList) `mappend`
                    defaultContext

            list <- postList tags pattern recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html"
                        (constField "title" title `mappend`
                            constField "posts" list `mappend`
                            defaultContext)
                >>= loadAndApplyTemplate "templates/default.html" allCtx
                >>= permalinkedifyUrls

    paginate 2 $ \index maxIndex itemsForPage -> do
        let id = fromFilePath $ "page/" ++ (show index) ++ "/index.html"
        create [id] $ do
            route idRoute
            compile $ do
                let allCtx =
                        field "recent" (\_ -> recentPostList) `mappend`
                        defaultContext
                    loadTeaser id = loadSnapshot id "teaser"
                                        >>= loadAndApplyTemplate "templates/teaser.html" (teaserCtx tags)
                                        >>= permalinkedifyUrls
                item1 <- loadTeaser (head itemsForPage)
                item2 <- loadTeaser (last itemsForPage)
                let body1 = itemBody item1
                    body2 = if length itemsForPage == 1 then "" else itemBody item2
                    postsCtx =
                        constField "posts" (body1 ++ body2) `mappend`
                        field "navlinkolder" (\_ -> return $ indexNavLink index 1 maxIndex) `mappend`
                        field "navlinknewer" (\_ -> return $ indexNavLink index (-1) maxIndex) `mappend`
                        defaultContext

                makeItem ""
                    >>= loadAndApplyTemplate "templates/blogpage.html" postsCtx
                    >>= loadAndApplyTemplate "templates/default.html" allCtx
                    >>= permalinkedifyUrls

    -- Render RSS feed
    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderRss feedConfiguration feedContext posts

    ---- List all posts in an archive
    create ["archive/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" post1Ctx (return posts) `mappend`
                    constField "title" "Articles"             `mappend`
                    defaultContext
            let allCtx =
                    field "recent" (\_ -> recentPostList)     `mappend`
                    defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" allCtx
                >>= permalinkedifyUrls

    create ["portfolio/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "products/*"
            let archiveCtx =
                    listField "posts" post1Ctx (return posts) `mappend`
                    constField "title" "Recent Projects"      `mappend`
                    defaultContext
            let allCtx =
                    field "recent" (\_ -> recentPostList) `mappend`
                    defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" allCtx
                >>= permalinkedifyUrls

-------------------------------------------------------------------------------
feedContext :: Context String
feedContext = mconcat
    [ rssBodyField "description"
    , rssTitleField "title"
    , wpUrlField "url"
    , dateField "date" "%B %e, %Y"
    ]

empty :: Compiler String
empty = return ""

rssTitleField :: String -> Context a
rssTitleField key = field key $ \i -> do
    value <- getMetadataField (itemIdentifier i) "title"
    let value' = liftM (replaceAll "&" (const "&amp;")) value
    maybe empty return value'

topermalinkedUrl :: FilePath -> String
topermalinkedUrl url =
    replaceAll "/index.html" (const "/") (toUrl url)

wpUrlField :: String -> Context a
wpUrlField key = field key $
    fmap (maybe "" topermalinkedUrl) . getRoute . itemIdentifier

rssBodyField :: String -> Context String
rssBodyField key = field key $
    return .
    (replaceAll "<iframe [^>]*>" (const "")) .
    (withUrls permalinked) .
    (withUrls absolute) .
    itemBody
  where
    permalinked x = replaceAll "/index.html" (const "/") x
    absolute x = if (head x) == '/' then (feedRoot feedConfiguration) ++ x else x


-------------------------------------------------------------------------------

post1Ctx :: Context String
post1Ctx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ dateField "date" "%B %e, %Y"
    , tagsField "tags" tags
    , defaultContext
    ]

teaserCtx :: Tags -> Context String
teaserCtx tags =
    field "teaser" teaserBody `mappend`
    (postCtx tags)


-------------------------------------------------------------------------------

postList :: Tags -> Pattern -> ([Item String] -> Compiler [Item String])
         -> Compiler String
postList tags pattern preprocess' = do
    itemTpl <- loadBody "templates/postitem.html"
    posts   <- preprocess' =<< loadAll (pattern .&&. hasNoVersion)
    applyTemplateList itemTpl (postCtx tags) posts

recentPostList :: Compiler String
recentPostList = do
    posts   <- fmap (take 7) . recentFirst =<< recentPosts
    itemTpl <- loadBody "templates/indexpostitem.html"
    list    <- applyTemplateList itemTpl defaultContext posts
    return list


-------------------------------------------------------------------------------
recentPosts :: Compiler [Item String]
recentPosts = do
    identifiers <- getMatches "posts/*"
    return [Item identifier "" | identifier <- identifiers]


-------------------------------------------------------------------------------
permalinkedRoute :: Routes
permalinkedRoute =
    gsubRoute "posts/" (const "") `composeRoutes`
        gsubRoute "pages/" (const "") `composeRoutes`
            gsubRoute "products/" (const "portfolio/") `composeRoutes`
                gsubRoute "^[0-9]{4}-[0-9]{2}-" (map replaceWithSlash)`composeRoutes`
                    gsubRoute ".markdown" (const "/index.html")
    where replaceWithSlash c = if c == '-' || c == '_'
                                   then '/'
                                   else c

-------------------------------------------------------------------------------
-- | Compiler form of 'permalinkedUrls' which automatically turns index.html
-- links into just the directory name
permalinkedifyUrls :: Item String -> Compiler (Item String)
permalinkedifyUrls item = do
    route <- getRoute $ itemIdentifier item
    return $ case route of
        Nothing -> item
        Just r  -> fmap permalinkedifyUrlsWith item


--------------------------------------------------------------------------------
-- | permalinkedify URLs in HTML
permalinkedifyUrlsWith :: String  -- ^ HTML to permalinkedify
                     -> String  -- ^ Resulting HTML
permalinkedifyUrlsWith = withUrls convert
  where
    convert x = replaceAll "/index.html" (const "/") x


--------------------------------------------------------------------------------
-- | RSS feed configuration.
--
feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "Katherine Chuang"
    , feedDescription = "RSS feed for Kat's blog"
    , feedAuthorName  = "Katherine Chuang"
    , feedAuthorEmail = "contact@katychuang.com"
    , feedRoot        = "http://katychuang.com"
    }


--------------------------------------------------------------------------------
labelRoute :: Routes
labelRoute =
    setExtension ".html" `composeRoutes`
    gsubRoute "." adjustLink `composeRoutes`
        gsubRoute "/" (const "") `composeRoutes`
            gsubRoute "^label" (const "label/") `composeRoutes`
                gsubRoute "-html" (const "/index.html")

adjustLink = (filter (not . isSlash)) . (map (toLower . replaceWithDash))

replaceWithDash :: Char -> Char
replaceWithDash c =
    if c == '.' || c == ' '
        then '-'
        else c

isSlash :: Char -> Bool
isSlash '/' = True
isSlash _   = False


--------------------------------------------------------------------------------
-- | Split list into equal sized sublists.
-- https://github.com/ian-ross/blog
chunk :: Int -> [a] -> [[a]]
chunk n [] = []
chunk n xs = ys : chunk n zs
    where (ys,zs) = splitAt n xs


--------------------------------------------------------------------------------
teaserBody :: Item String -> Compiler String
teaserBody item = do
    let body = itemBody item
    return $ extractTeaser . maxLengthTeaser . compactTeaser $ body
  where
    extractTeaser :: String -> String
    extractTeaser [] = []
    extractTeaser xs@(x : xr)
        | "<!-- more -->" `isPrefixOf` xs = []
        | otherwise                       = x : extractTeaser xr

    maxLengthTeaser :: String -> String
    maxLengthTeaser s = if findIndex (isPrefixOf "<!-- more -->") (tails s) == Nothing
                            then unwords (take 60 (words s))
                            else s

    compactTeaser :: String -> String
    compactTeaser =
        (replaceAll "<iframe [^>]*>" (const "")) .
        (replaceAll "<img [^>]*>" (const "")) .
        (replaceAll "<p>" (const "")) .
        (replaceAll "</p>" (const "")) .
        (replaceAll "<blockquote>" (const "")) .
        (replaceAll "</blockquote>" (const "")) .
        (replaceAll "<strong>" (const "")) .
        (replaceAll "</strong>" (const "")) .
        (replaceAll "<ol>" (const "")) .
        (replaceAll "</ol>" (const "")) .
        (replaceAll "<ul>" (const "")) .
        (replaceAll "</ul>" (const "")) .
        (replaceAll "<li>" (const "")) .
        (replaceAll "</li>" (const "")) .
        (replaceAll "<h[0-9][^>]*>" (const "")) .
        (replaceAll "</h[0-9]>" (const "")) .
        (replaceAll "<pre.*" (const "")) .
        (replaceAll "<a [^>]*>" (const "")) .
        (replaceAll "</a>" (const "")) .
        (replaceAll "<table [^>]*>" (const "")) .
        (replaceAll "<table>" (const "")) .
        (replaceAll "<tr>" (const "")) .
        (replaceAll "</tr>" (const "")) .
        (replaceAll "<td [^>]*>" (const "")) .
        (replaceAll "<td>" (const "")) .
        (replaceAll "</td>" (const "")) .
        (replaceAll "</table>" (const "")) .
        (replaceAll "<tbody>" (const "")) .
        (replaceAll "</tbody>" (const "")) .
        (replaceAll "<div [^>]*>" (const "")) .
        (replaceAll "<embed [^>]*>" (const "")) .
        (replaceAll "<blockquote [^>]*>" (const "")) .
        (replaceAll "<blockquote>" (const ""))


--------------------------------------------------------------------------------
-- | Generate navigation link HTML for stepping between index pages.
-- https://github.com/ian-ross/blog
--
indexNavLink :: Int -> Int -> Int -> String
indexNavLink n d maxn = renderHtml ref
  where ref = if (refPage == "") then ""
              else H.a ! A.href (toValue $ toUrl $ refPage) $
                   (preEscapedString lab)
        lab = if (d > 0) then "Older Entries &raquo;" else "&laquo; Newer Entries"
        refPage = if (n + d < 1 || n + d > maxn) then ""
                  else case (n + d) of
                    1 -> "/page/1/"
                    _ -> "/page/" ++ (show $ n + d) ++ "/"


--------------------------------------------------------------------------------
paginate:: Int -> (Int -> Int -> [Identifier] -> Rules ()) -> Rules ()
paginate itemsPerPage rules = do
    identifiers <- getMatches "posts/*"

    let sorted = reverse $ sortBy byDate identifiers
        chunks = chunk itemsPerPage sorted
        maxIndex = length chunks
        pageNumbers = take maxIndex [1..]
        process i is = rules i maxIndex is
    zipWithM_ process pageNumbers chunks
        where
            byDate id1 id2 =
                let fn1 = takeFileName $ toFilePath id1
                    fn2 = takeFileName $ toFilePath id2
                    parseTime' fn = parseTime defaultTimeLocale "%Y-%m-%d" $ intercalate "-" $ take 3 $ splitAll "-" fn
                in compare ((parseTime' fn1) :: Maybe UTCTime) ((parseTime' fn2) :: Maybe UTCTime)
