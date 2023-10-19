module Ui exposing (Document, Item, Sample(..), Ui, markdown, viewHeading, viewItem)

import Html exposing (Html)
import Html.Attributes as Attr
import Less as Less
import Less.Ui as Ui
import Less.Ui.Html as Ui exposing (Region(..))
import Markdown.Html
import Markdown.Parser as Markdown
import Markdown.Renderer exposing (defaultHtmlRenderer)


type alias Ui =
    Ui.Html Region () ()


type alias Document =
    Less.Document ()



------- Types ------


type alias Item =
    { fragment : String
    , category : String
    , timeframe : String
    , title : String
    , description : String
    , sample : Sample
    , info : String
    }


navLink : String -> Ui -> Ui
navLink fragment =
    Ui.goTo []
        { destination = "#" ++ fragment
        , inHeader = True
        , label = markdown ("![" ++ fragment ++ "](" ++ fragment ++ "-icon.png)")
        }


viewItem : Item -> Ui
viewItem { fragment, category, timeframe, title, description, sample, info } =
    (List.concat >> Ui.block "ul" [ Attr.id fragment ])
        [ Ui.html
            [ Html.span [ Attr.class "category" ] [ Html.text category ]
            , Html.span [ Attr.class "timeframe" ] (markdown timeframe)
            ]
        , Ui.goTo []
            { destination = "#" ++ fragment
            , inHeader = False
            , label = [ Html.h1 [] (markdown title) ]
            }
            []
        , Ui.html [ Html.div [ Attr.class "description" ] (markdown description) ]
        , viewSample sample
        , Ui.html [ Html.div [ Attr.class "info" ] (markdown info) ]
        ]
        ++ navLink fragment
            (Ui.block "center-me" [ Attr.attribute "hash" fragment ] [])


viewWhenHash : String -> Ui -> Ui
viewWhenHash hash =
    Ui.goTo []
        { destination = "#" ++ hash
        , inHeader = False
        , label = []
        }



--|> Ui.with Info (Ui.foliage (List.indexedMap (\i -> Tuple.pair (String.fromInt i)) (markdown info)))


viewHeading : Ui
viewHeading =
    Ui.html (markdown """
_Flupsi's Interactive Media Portfolio_

    \u{00A0}
    \u{00A0}
    \u{00A0}

""")


type Sample
    = Sample String
    | Diagram
        { left : List String
        , center : String
        , right : List String
        , bottom : List String
        }
    | Video
    | Inclusion
        { left : List String
        , source : String
        , right : List String
        , bottom : List String
        }
    | Carousel String (List String)


viewSample : Sample -> Ui
viewSample sample =
    let
        addBeforeAndAfter : Ui -> Ui
        addBeforeAndAfter items =
            Ui.block "div" [ Attr.class "before" ] [] ++ items ++ Ui.block "div" [ Attr.class "after" ] []

        flexRow : List (Html.Attribute ()) -> Ui -> Ui
        flexRow attrs =
            Ui.block "div" (Attr.class "row" :: attrs)

        flexColumn : List (Html.Attribute ()) -> Ui -> Ui
        flexColumn attrs =
            Ui.block "div" (Attr.class "column" :: attrs)

        image : { a | filename : String, alt : String } -> ( String, Html msg )
        image { alt, filename } =
            ( alt
            , Html.img
                [ Attr.title alt
                , Attr.src filename
                , Attr.attribute "loading" "lazy"
                ]
                []
            )

        wrapLegends : List String -> Ui
        wrapLegends =
            List.concatMap
                (\legend ->
                    Ui.html
                        [ Html.div [ Attr.class "legend" ]
                            [ Html.div [ Attr.class "legend-container" ]
                                (markdown legend)
                            ]
                        ]
                )
    in
    case sample of
        Sample md ->
            Ui.html [ Html.div [ Attr.class "sample" ] (markdown md) ]

        Diagram { left, center, right, bottom } ->
            flexRow [ Attr.class "sample" ]
                (flexColumn [ Attr.class "left" ]
                    (addBeforeAndAfter (wrapLegends left))
                    ++ flexColumn [ Attr.class "center" ]
                        (Ui.html (markdown center) ++ flexRow [] (wrapLegends bottom))
                    ++ flexColumn [ Attr.class "right" ]
                        (addBeforeAndAfter (wrapLegends right))
                )

        Video ->
            []

        Inclusion { left, source, right, bottom } ->
            flexRow [ Attr.class "sample" ]
                (flexColumn [ Attr.class "left" ]
                    (addBeforeAndAfter (wrapLegends left))
                    ++ flexColumn [ Attr.class "center" ]
                        (Ui.html
                            [ Html.node "silence-console"
                                []
                                [ Html.node "iframe"
                                    [ Attr.src source
                                    , Attr.attribute "is" "silent-iframe"
                                    , Attr.attribute "loading" "lazy"
                                    ]
                                    []
                                ]
                            ]
                            ++ flexRow [] (wrapLegends bottom)
                        )
                    ++ flexColumn [ Attr.class "right" ]
                        (addBeforeAndAfter (wrapLegends right))
                )

        Carousel fragment entries ->
            List.indexedMap
                (\i entry ->
                    let
                        id : String
                        id =
                            fragment ++ String.fromInt i

                        link : Ui
                        link =
                            Ui.goTo []
                                { destination = "#" ++ id
                                , inHeader = False
                                , label = markdown id
                                }
                                []

                        centerer : Ui
                        centerer =
                            Ui.block "center-me-horizontally" [] []
                                |> viewWhenHash id

                        content : Ui
                        content =
                            Ui.html (markdown entry)
                    in
                    Ui.block "div" [ Attr.class "entry" ] (link ++ centerer ++ content)
                )
                entries
                |> List.concat
                |> Ui.block "div" [ Attr.class "scrolling" ]
                |> Ui.block "div" [ Attr.class "carousel sample" ]



------- Markdown -------


specialRenderer : Markdown.Renderer.Renderer (Html msg)
specialRenderer =
    { defaultHtmlRenderer
        | link =
            \link content ->
                case Maybe.map (String.split " | ") link.title of
                    Just [ simpleTitle ] ->
                        Html.a
                            [ Attr.href link.destination
                            , Attr.title simpleTitle
                            , Attr.target "blank_"
                            ]
                            content

                    Just (simpleTitle :: details) ->
                        viewHtmlLegend content
                            (Html.a
                                [ Attr.class "popup"
                                , Attr.tabindex 0
                                , Attr.href link.destination
                                , Attr.target "blank_"
                                ]
                            )
                            ("[" ++ String.join " | " details ++ "](" ++ link.destination ++ """ \"""" ++ simpleTitle ++ """\"""" ++ ")" |> markdown)

                    _ ->
                        Html.a
                            [ Attr.href link.destination
                            , Attr.target "blank_"
                            ]
                            content
        , html =
            Markdown.Html.oneOf
                [ Markdown.Html.tag "more"
                    (\summary ->
                        viewHtmlLegend (markdown summary)
                            (Html.span [ Attr.class "popup", Attr.title summary, Attr.tabindex 0 ])
                    )
                    |> Markdown.Html.withAttribute "summary"
                , Markdown.Html.tag "url"
                    (Html.span [ Attr.class "url", Attr.title "The URL" ])
                , Markdown.Html.tag "carousel"
                    (\renderedChildren ->
                        Html.div [ Attr.class "carousel" ]
                            [ Html.div [ Attr.class "scrolling" ]
                                renderedChildren
                            ]
                    )
                , Markdown.Html.tag "alternate"
                    (Html.node "alternate"
                        []
                    )
                , Markdown.Html.tag "single-column"
                    (Html.node "single-column"
                        []
                    )
                , Markdown.Html.tag "highlight"
                    (Html.div [ Attr.class "highlight" ])
                , Markdown.Html.tag "youtube"
                    (\src _ ->
                        Html.video
                            [ Attr.tabindex -1
                            , Attr.src src
                            ]
                            []
                    )
                    |> Markdown.Html.withAttribute "src"
                , Markdown.Html.tag "over"
                    (\overlays renderedChildren ->
                        let
                            renderOverlay str =
                                case String.split " " str of
                                    x :: y :: rotation :: id :: content ->
                                        Html.div
                                            [ Attr.class "overlay"
                                            , Attr.id id
                                            , Attr.style "transform"
                                                ("translate(" ++ x ++ "," ++ y ++ ") rotate(" ++ rotation ++ ")")
                                            ]
                                            (markdown (String.join " " content))

                                    _ ->
                                        Html.div [ Attr.class "overlay" ]
                                            (markdown str)
                        in
                        Html.div
                            [ Attr.class "overlaid" ]
                            (renderedChildren
                                ++ List.map renderOverlay
                                    (String.split "+++ " overlays)
                            )
                    )
                    |> Markdown.Html.withAttribute "lays"
                ]
        , image =
            \imageInfo ->
                case imageInfo.title of
                    Just title ->
                        Html.img
                            [ Attr.src imageInfo.src
                            , Attr.alt imageInfo.alt
                            , Attr.title title
                            , Attr.attribute "loading" "lazy"
                            ]
                            []

                    Nothing ->
                        Html.img
                            [ Attr.src imageInfo.src
                            , Attr.alt imageInfo.alt
                            , Attr.attribute "loading" "lazy"
                            ]
                            []
    }


markdown : String -> List (Html msg)
markdown markdownInput =
    case
        markdownInput
            |> Markdown.parse
            |> Result.mapError (List.map Markdown.deadEndToString >> String.join "\n")
            |> Result.andThen (\ast -> Markdown.Renderer.render specialRenderer ast)
    of
        Ok rendered ->
            rendered

        Err errors ->
            [ Html.text errors ]


viewHtmlLegend : List (Html msg) -> (List (Html msg) -> Html msg) -> List (Html msg) -> Html msg
viewHtmlLegend summary wrapper popup =
    Html.span [ Attr.class "dropdown" ]
        [ Html.div [ Attr.class "summary", Attr.tabindex 0 ] summary
        , wrapper
            (Html.node "keep-inside" [] []
                :: popup
            )
        ]
