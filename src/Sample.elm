module Sample exposing (Legend, LegendPart(..), Sample(..), markdown, view)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Keyed as Keyed
import Markdown.Parser as Markdown
import Markdown.Renderer
import Restrictive
import Restrictive.Layout.Region exposing (Aspect(..))
import Restrictive.State exposing (Flag)
import Restrictive.Ui as Ui
import Ui exposing (Ui)


type Sample
    = Diagram
        { left : List Legend
        , filename : String
        , alt : String
        , right : List Legend
        , bottom : List Legend
        }


type alias Legend =
    List LegendPart


type LegendPart
    = Md String
    | More String Legend


viewLegend : Legend -> Ui
viewLegend =
    List.concatMap
        (\part ->
            case part of
                Md str ->
                    Ui.html ( "", Html.div [] (markdown str) )

                More summary details ->
                    Ui.html ( "", Html.div [ Attr.class "summary", Attr.tabindex 0 ] (markdown summary) )
                        ++ Ui.wrap (\popup -> [ ( "", Keyed.node "span" [ Attr.class "popup", Attr.tabindex 0 ] popup ) ]) (viewLegend details)
                        |> Ui.wrap (\dropdown -> [ ( "", Keyed.node "span" [ Attr.class "dropdown" ] dropdown ) ])
        )


markdown : String -> List (Html msg)
markdown markdownInput =
    case
        markdownInput
            |> Markdown.parse
            |> Result.mapError deadEndsToString
            |> Result.andThen (\ast -> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer ast)
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

                wrapLegend : List Legend -> Ui
                wrapLegend =
                    List.concatMap (viewLegend >> Ui.wrap (\legend -> [ ( "", Keyed.node "div" [ Attr.class "legend" ] legend ) ]))
            in
            Ui.wrap (flex "sample row")
                (Ui.wrap (addBeforeAndAfter >> flex "column left") (wrapLegend left)
                    ++ Ui.wrap (flex "column center") (Ui.html image ++ Ui.wrap (flex "row") (wrapLegend bottom))
                    ++ Ui.wrap (addBeforeAndAfter >> flex "column right") (wrapLegend right)
                )
