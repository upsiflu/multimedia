module Sample exposing (Sample(..), Ui, list, markdown, view)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Keyed as Keyed
import Markdown.Parser as Markdown
import Markdown.Renderer
import Restrictive exposing (Application, application)
import Restrictive.Layout
import Restrictive.Layout.Region exposing (Aspect(..))
import Restrictive.State
import Restrictive.Ui as Ui


type alias Ui =
    Ui.Ui
        Aspect
        ( String, Html () )


type Sample
    = Diagram
        { left : Ui
        , filename : String
        , alt : String
        , right : Ui
        , bottom : Ui
        }


list : List String -> Ui
list =
    List.map markdown
        >> List.indexedMap (\i -> Tuple.pair (String.fromInt i))
        >> Ui.foliage


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
                (Ui.wrap (addBeforeAndAfter >> flex "column left") left
                    ++ Ui.wrap (flex "column") (Ui.html image ++ Ui.wrap (flex "row") bottom)
                    ++ Ui.wrap (addBeforeAndAfter >> flex "column right") right
                )