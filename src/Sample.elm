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
        { left : Legend
        , filename : String
        , alt : String
        , right : Legend
        , bottom : Legend
        }


type alias Legend =
    List LegendPart


type LegendPart
    = Md String
    | More Flag String Legend
    | Mixed Legend


viewLegend : Legend -> Ui
viewLegend =
    List.concatMap
        (\part ->
            case part of
                Md str ->
                    Ui.html ( "", markdown str )

                More flag summary details ->
                    Ui.toggle [ markdown summary ] flag
                        |> Ui.with Scene (viewLegend details)
                        |> Ui.wrap (\dropdown -> [ ( "", Keyed.node "div" [ Attr.class "dropdown" ] dropdown ) ])

                Mixed legend ->
                    viewLegend legend
                        |> Ui.wrap (\children -> [ ( "", Keyed.node "div" [ Attr.class "mixed markdown" ] children ) ])
        )


markdown : String -> Html msg
markdown markdownInput =
    Html.div [ Attr.class "markdown" ]
        [ case
            markdownInput
                |> Markdown.parse
                |> Result.mapError deadEndsToString
                |> Result.andThen (\ast -> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer ast)
          of
            Ok rendered ->
                Html.div [] rendered

            Err errors ->
                Html.text errors
        ]


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
            in
            Ui.wrap (flex "sample row")
                (Ui.wrap (addBeforeAndAfter >> flex "column left") (viewLegend left)
                    ++ Ui.wrap (flex "column") (Ui.html image ++ Ui.wrap (flex "row") (viewLegend bottom))
                    ++ Ui.wrap (addBeforeAndAfter >> flex "column right") (viewLegend right)
                )
