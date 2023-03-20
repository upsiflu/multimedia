module Content exposing (Content, Msg, init, update, view)

{-| A /very/ simple blog post with a custom inline element for some cool text formatting.

This is to get you started.

-}

import Html exposing (Html)
import Html.Attributes as Attr
import Http
import Mark
import Mark.Error


init : ( Content, Cmd Msg )
init =
    ( { source = Nothing }
    , Http.get
        { expect = Http.expectString GotSrc
        , url = "build/Ipsum.emu"
        }
    )


type alias Content =
    { source : Maybe String }


type Msg
    = GotSrc (Result Http.Error String)


update : Msg -> Content -> ( Content, Cmd Msg )
update msg content =
    case msg of
        GotSrc result ->
            case result of
                Ok src ->
                    ( { content | source = Just src }
                    , Cmd.none
                    )

                Err _ ->
                    ( content, Cmd.none )


view : Content -> Html msg
view model =
    case model.source of
        Just source ->
            case Mark.compile document source of
                Mark.Success html ->
                    Html.div [] html.body

                Mark.Almost { errors, result } ->
                    -- This is the case where there has been an error,
                    -- but it has been caught by `Mark.onError` and is still rendereable.
                    Html.div []
                        [ Html.div [] (viewErrors errors)
                        , Html.div [] result.body
                        ]

                Mark.Failure errors ->
                    Html.div []
                        (viewErrors errors)

        Nothing ->
            Html.text "Loading..."


viewErrors : List Mark.Error.Error -> List (Html msg)
viewErrors errors =
    List.map
        (Mark.Error.toHtml Mark.Error.Light)
        errors


document : Mark.Document { body : List (Html a), metadata : { author : String, description : List (Html msg), title : List (Html a) } }
document =
    Mark.documentWith
        (\meta body ->
            { body = body
            , metadata = meta
            }
        )
        { body =
            Mark.manyOf
                [ header
                , image
                , list
                , code
                , Mark.map (Html.p []) text
                ]
        , metadata = metadata
        }



{- Handle Text -}


text : Mark.Block (List (Html msg))
text =
    Mark.textWith
        { inlines =
            [ Mark.annotation "link"
                (\texts url ->
                    Html.a [ Attr.href url ] (List.map (\( styles, string ) -> viewText styles string) texts)
                )
                |> Mark.field "url" Mark.string
            , Mark.verbatim "drop"
                (\str ->
                    let
                        drop : String
                        drop =
                            String.left 1 str

                        lede : String
                        lede =
                            String.dropLeft 1 str
                    in
                    Html.span []
                        [ Html.span [ Attr.class "drop-capital" ]
                            [ Html.text drop ]
                        , Html.span [ Attr.class "lede" ]
                            [ Html.text lede ]
                        ]
                )
            ]
        , replacements = Mark.commonReplacements
        , view =
            \styles string ->
                viewText styles string
        }


viewText : { a | bold : Bool, italic : Bool, strike : Bool } -> String -> Html msg
viewText styles string =
    if styles.bold || styles.italic || styles.strike then
        Html.span
            [ Attr.classList
                [ ( "bold", styles.bold )
                , ( "italic", styles.italic )
                , ( "strike", styles.strike )
                ]
            ]
            [ Html.text string ]

    else
        Html.text string



{- Handle Metadata -}


metadata : Mark.Block { author : String, description : List (Html msg), title : List (Html a) }
metadata =
    Mark.record "Article"
        (\author description title ->
            { author = author
            , description = description
            , title = title
            }
        )
        |> Mark.field "author" Mark.string
        |> Mark.field "description" text
        |> Mark.field "title" text
        |> Mark.toBlock



{- Handle Blocks -}


header : Mark.Block (Html msg)
header =
    Mark.block "H1"
        (\children ->
            Html.h1 []
                children
        )
        text


image : Mark.Block (Html msg)
image =
    Mark.record "Image"
        (\src description ->
            Html.img
                [ Attr.src src
                , Attr.alt description
                , Attr.style "float" "left"
                , Attr.style "margin-right" "48px"
                ]
                []
        )
        |> Mark.field "src" Mark.string
        |> Mark.field "description" Mark.string
        |> Mark.toBlock


code : Mark.Block (Html msg)
code =
    Mark.block "Code"
        (\str ->
            Html.pre
                [ Attr.style "padding" "12px"
                , Attr.style "background-color" "#eee"
                ]
                [ Html.text str ]
        )
        Mark.string



{- Handling bulleted and numbered lists -}


list : Mark.Block (Html msg)
list =
    Mark.tree "List" renderList (Mark.map (Html.div []) text)



-- Note: we have to define this as a separate function because
-- `Items` and `Node` are a pair of mutually recursive data structures.
-- It's easiest to render them using two separate functions:
-- renderList and renderItem


renderList : Mark.Enumerated (Html msg) -> Html msg
renderList (Mark.Enumerated enum) =
    let
        group : List (Html.Attribute msg) -> List (Html msg) -> Html msg
        group =
            case enum.icon of
                Mark.Bullet ->
                    Html.ul

                Mark.Number ->
                    Html.ol
    in
    group []
        (List.map renderItem enum.items)


renderItem : Mark.Item (Html msg) -> Html msg
renderItem (Mark.Item item) =
    Html.li []
        [ Html.div [] item.content
        , renderList item.children
        ]
