module Sample exposing (Sample(..), markdown, view)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Keyed as Keyed
import Markdown.Html
import Markdown.Parser as Markdown
import Markdown.Renderer exposing (defaultHtmlRenderer)
import Restrictive
import Restrictive.Layout.Region exposing (Aspect(..))
import Restrictive.State exposing (Flag)
import Restrictive.Ui as Ui
import Ui exposing (Ui)


type Sample
    = Diagram
        { left : List String
        , filename : String
        , alt : String
        , right : List String
        , bottom : List String
        }


viewHtmlLegend summary popup =
    Html.span [ Attr.class "dropdown" ]
        [ Html.div [ Attr.class "summary", Attr.tabindex 0 ] summary
        , Html.span [ Attr.class "popup", Attr.tabindex 0 ]
            (Html.node "keep-inside" [] []
                :: popup
            )
        ]


specialRenderer : Markdown.Renderer.Renderer (Html msg)
specialRenderer =
    { defaultHtmlRenderer
        | link =
            \link content ->
                case Maybe.map (String.split " | ") (Debug.log "Link content with |" link.title) of
                    Just [ simpleTitle ] ->
                        Html.a
                            [ Attr.href link.destination
                            , Attr.title simpleTitle
                            ]
                            content

                    Just (simpleTitle :: details) ->
                        viewHtmlLegend content
                            ("[" ++ String.join " | " details ++ "](" ++ link.destination ++ """ \"""" ++ simpleTitle ++ """\"""" ++ ")" |> markdown)

                    _ ->
                        Html.a [ Attr.href link.destination ] content
        , html =
            Markdown.Html.oneOf
                [ Markdown.Html.tag "more"
                    (\summary renderedChildren ->
                        viewHtmlLegend (markdown summary) renderedChildren
                    )
                    |> Markdown.Html.withAttribute "summary"
                ]
    }


markdown : String -> List (Html msg)
markdown markdownInput =
    case
        markdownInput
            |> Markdown.parse
            |> Result.mapError deadEndsToString
            |> Result.andThen (\ast -> Markdown.Renderer.render specialRenderer ast)
    of
        Ok rendered ->
            rendered

        Err errors ->
            [ Html.text errors ]


deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.deadEndToString
        |> String.join "\n"


view : Sample -> Ui
view sample =
    case sample of
        Diagram { left, filename, alt, right, bottom } ->
            let
                addBeforeAndAfter : List ( String, Html msg ) -> List ( String, Html msg )
                addBeforeAndAfter items =
                    ( "before", Html.div [ Attr.class "before" ] [] ) :: items ++ [ ( "after", Html.div [ Attr.class "after" ] [] ) ]

                flex : String -> List ( String, Html msg ) -> List ( String, Html msg )
                flex direction items =
                    [ ( "", Keyed.node "div" [ Attr.class direction ] items ) ]

                image : ( String, Html msg )
                image =
                    ( alt, Html.img [ Attr.title alt, Attr.src filename ] [] )

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
            Ui.wrap (flex "sample row")
                (Ui.wrap (addBeforeAndAfter >> flex "column left") (wrapLegends left)
                    ++ Ui.wrap (flex "column center") (Ui.html image ++ Ui.wrap (flex "row") (wrapLegends bottom))
                    ++ Ui.wrap (addBeforeAndAfter >> flex "column right") (wrapLegends right)
                )
