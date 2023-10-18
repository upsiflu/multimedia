module Ui exposing (Document, Item, Sample(..), Ui, markdown, viewItem, viewMarkdown)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Keyed as Keyed
import Less as Less
import Less.Link exposing (Flag)
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
    { fragment : Flag
    , category : String
    , timeframe : String
    , title : String
    , description : String
    , sample : Sample
    , info : String
    }


viewMarkdown : String -> Ui
viewMarkdown =
    markdown >> List.concatMap (Tuple.pair "" >> Ui.html)


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
            , Ui.wrap (\h -> [ ( "anchor", Html.a [ Attr.href ("#" ++ fragment) ] [ Keyed.node "h1" [] h ] ) ]) (List.concatMap Ui.html (markdown title |> List.map (Tuple.pair "")))
            ]
        , markdown description |> Html.div [ Attr.class "description" ] |> Tuple.pair "description" |> Ui.html
        , viewSample sample
        , markdown info |> Html.div [ Attr.class "info" ]
        ]
        ++ navLink fragment
            (Ui.node "center-me" [ Attr.attribute "hash" fragment ])


viewWhenHash : Flag -> Ui -> Ui
viewWhenHash flag ui =
    Ui.byLocation
        (\( _, hash ) ->
            if hash == Just flag then
                ui

            else
                []
        )



--|> Ui.with Info (Ui.foliage (List.indexedMap (\i -> Tuple.pair (String.fromInt i)) (markdown info)))


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
    | Carousel Flag (List String)


viewSample : Sample -> Ui
viewSample sample =
    let
        addBeforeAndAfter : List ( String, Html msg ) -> List ( String, Html msg )
        addBeforeAndAfter items =
            ( "before", Html.div [ Attr.class "before" ] [] ) :: items ++ [ ( "after", Html.div [ Attr.class "after" ] [] ) ]

        flex : String -> List ( String, Html msg ) -> List ( String, Html msg )
        flex direction items =
            [ ( "", Keyed.node "div" [ Attr.class direction ] items ) ]

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
                        ( ""
                        , Html.div [ Attr.class "legend" ]
                            [ Html.div [ Attr.class "legend-container" ]
                                (markdown legend)
                            ]
                        )
                )
    in
    case sample of
        Sample md ->
            Ui.html ( "sample", Html.div [ Attr.class "sample" ] (markdown md) )

        Diagram { left, center, right, bottom } ->
            Ui.wrap (flex "sample row")
                (Ui.wrap (addBeforeAndAfter >> flex "column left") (wrapLegends left)
                    ++ Ui.wrap (flex "column center") (List.concatMap (Tuple.pair "center" >> Ui.html) (markdown center) ++ Ui.wrap (flex "row") (wrapLegends bottom))
                    ++ Ui.wrap (addBeforeAndAfter >> flex "column right") (wrapLegends right)
                )

        Video ->
            Ui.singleton

        Inclusion { left, source, right, bottom } ->
            Ui.wrap (flex "sample row")
                (Ui.wrap (addBeforeAndAfter >> flex "column left") (wrapLegends left)
                    ++ Ui.wrap (flex "column center")
                        (Ui.html
                            ( "inclusion"
                            , Html.node "silence-console"
                                []
                                [ Html.node "iframe"
                                    [ Attr.src source
                                    , Attr.attribute "is" "silent-iframe"
                                    , Attr.attribute "loading" "lazy"
                                    ]
                                    []
                                ]
                            )
                            ++ Ui.wrap (flex "row") (wrapLegends bottom)
                        )
                    ++ Ui.wrap (addBeforeAndAfter >> flex "column right") (wrapLegends right)
                )

        Carousel flag entries ->
            List.indexedMap
                (\i entry ->
                    let
                        id : Flag
                        id =
                            flag ++ String.fromInt i

                        link : Ui
                        link =
                            Less.goTo ( Nothing, Just id )

                        centerer : Ui
                        centerer =
                            Ui.html ( "centering", Html.node "center-me-horizontally" [] [] )
                                |> viewWhenHash id

                        content : Ui
                        content =
                            viewMarkdown entry
                    in
                    link
                        ++ centerer
                        ++ content
                        |> Ui.wrap
                            (\entry_ ->
                                [ ( "entry", Keyed.node "div" [ Attr.class "entry" ] entry_ ) ]
                            )
                )
                entries
                |> List.concat
                |> Ui.wrap
                    (\entries_ ->
                        [ ( "carousel" ++ flag
                          , Html.div
                                [ Attr.class "carousel sample" ]
                                [ Keyed.node "div" [ Attr.class "scrolling" ] entries_ ]
                          )
                        ]
                    )



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
