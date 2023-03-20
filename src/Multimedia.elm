module Multimedia exposing (Multimedia, main, Msg)

{-|

@docs Multimedia, main, Msg

-}

import Html exposing (Html)
import Html.Attributes as Attr
import Mark
import Mark.Error
import Restrictive exposing (Application, application)
import Restrictive.Layout
import Restrictive.Layout.Region exposing (Aspect(..))
import Restrictive.State
import Restrictive.Ui as Ui



----


main_ =
    case Mark.compile document source of
        Mark.Success html ->
            Html.div [] html.body

        Mark.Almost { result, errors } ->
            -- This is the case where there has been an error,
            -- but it has been caught by `Mark.onError` and is still rendereable.
            Html.div []
                [ Html.div [] (viewErrors errors)
                , Html.div [] result.body
                ]

        Mark.Failure errors ->
            Html.div []
                (viewErrors errors)


viewErrors errors =
    List.map
        (Mark.Error.toHtml Mark.Error.Light)
        errors


stylesheet =
    """
@import url('https://fonts.googleapis.com/css?family=EB+Garamond');
.italic {
    font-style: italic;
}
.bold {
    font-weight: bold;
}
.strike {
    text-decoration: line-through;
}
body {
    font-family: 'EB Garamond', serif;
    font-size: 20px;
    width: 600px;
    margin-left:auto;
    margin-right:auto;
    padding: 48px 0;
}
.drop-capital {
    font-size: 2.95em;
    line-height: 0.89em;
    float:left;
    margin-right: 8px;
}
.lede {
    font-variant: small-caps;
    margin-left: -15px;
}
"""


document =
    Mark.documentWith
        (\meta body ->
            { metadata = meta
            , body =
                Html.node "style" [] [ Html.text stylesheet ]
                    :: Html.h1 [] meta.title
                    :: body
            }
        )
        -- We have some required metadata that starts our document.
        { metadata = metadata
        , body =
            Mark.manyOf
                [ header
                , image
                , list
                , code
                , Mark.map (Html.p []) text
                ]
        }



{- Handle Text -}


text =
    Mark.textWith
        { view =
            \styles string ->
                viewText styles string
        , replacements = Mark.commonReplacements
        , inlines =
            [ Mark.annotation "link"
                (\texts url ->
                    Html.a [ Attr.href url ] (List.map (applyTuple viewText) texts)
                )
                |> Mark.field "url" Mark.string
            , Mark.verbatim "drop"
                (\str ->
                    let
                        drop =
                            String.left 1 str

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
        }


applyTuple fn ( one, two ) =
    fn one two


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


header =
    Mark.block "H1"
        (\children ->
            Html.h1 []
                children
        )
        text


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



{- Article Source
   Note: Here we're defining our source inline, but checkout the External Files example.
   External files have a syntax highlighter in VS Code, and a CLI utility to check for errors.  It's a way better experience!
-}
-- [Lorem Ipsum is simply---]{drop}}dummy text of the printing and [typesetting industry]{link| url = http://mechanical-elephant.com}. Lorem Ipsum has been the industry's /standard/ dummy text ever since the 1500's, when an "unknown printer" took a galley of type and scrambled it to<>make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was *popularised* in the 1960's with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.


source =
    """
|> Article 
    author = Matthew Griffith
    title = How I Learned /elm-markup/
    description =
        How I learned to use elm-markup.
`Lorem Ipsum is simply`{drop} --- dummy text of the printing and [typesetting industry]{link| url = http://mechanical-elephant.com }. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In id pellentesque elit, id sollicitudin felis. Morbi eu risus molestie enim suscipit auctor. Morbi pharetra, nisl ut finibus ornare, dolor tortor aliquet est, quis feugiat odio sem ut sem. Nullam eu bibendum ligula. Nunc mollis tortor ac rutrum interdum. Nunc ultrices risus eu pretium interdum. Nullam maximus convallis quam vitae ullamcorper. Praesent sapien nulla, hendrerit quis tincidunt a, placerat et felis. Nullam consectetur magna nec lacinia egestas. Aenean rutrum nunc diam.
Morbi ut porta justo. Integer ac eleifend sem. Fusce sed auctor velit, et condimentum quam. Vivamus id mollis libero, mattis commodo mauris. In hac habitasse platea dictumst. Duis eu lobortis arcu, ac volutpat ante. Duis sapien enim, auctor vitae semper vitae, tincidunt et justo. Cras aliquet turpis nec enim mattis finibus. Nulla diam urna, semper ut elementum at, porttitor ut sapien. Pellentesque et dui neque. In eget lectus odio. Fusce nulla velit, eleifend sit amet malesuada ac, hendrerit id neque. Curabitur blandit elit et urna fringilla, id commodo quam fermentum. 
But for real, here's a kitten.
|> Image 
    src = http://placekitten.com/g/200/300
    description = What a cute kitten.
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In id pellentesque elit, id sollicitudin felis. Morbi eu risus molestie enim suscipit auctor. Morbi pharetra, nisl ut finibus ornare, dolor tortor aliquet est, quis feugiat odio sem ut sem. Nullam eu bibendum ligula. Nunc mollis tortor ac rutrum interdum. Nunc ultrices risus eu pretium interdum. Nullam maximus convallis quam vitae ullamcorper. Praesent sapien nulla, hendrerit quis tincidunt a, placerat et felis. Nullam consectetur magna nec lacinia egestas. Aenean rutrum nunc diam.
Morbi ut porta justo. Integer ac eleifend sem. Fusce sed auctor velit, et condimentum quam. Vivamus id mollis libero, mattis commodo mauris. In hac habitasse platea dictumst. Duis eu lobortis arcu, ac volutpat ante. Duis sapien enim, auctor vitae semper vitae, tincidunt et justo. Cras aliquet turpis nec enim mattis finibus. Nulla diam urna, semper ut elementum at, porttitor ut sapien. Pellentesque et dui neque. In eget lectus odio. Fusce nulla velit, eleifend sit amet malesuada ac, hendrerit id neque. Curabitur blandit elit et urna fringilla, id commodo quam fermentum. 
|> Code
    This is a code block
    With Multiple lines
|> H1
    My section on /lists/
What does a *list* look like?
|> List
    1.  This is definitely the first thing.
        Add all together now
        With some Content
    -- Another thing.
        1. sublist
        -- more sublist
            -- indented
        -- other sublist
            -- subthing
            -- other subthing
    -- and yet, another
        --  and another one
            With some content
"""



----


{-| -}
type alias Msg =
    ()


{-| -}
type alias Multimedia =
    {}


init : ( Multimedia, Cmd Msg )
init =
    ( {}, Cmd.none )


update : Msg -> Multimedia -> ( Multimedia, Cmd Msg )
update () multimedia =
    ( multimedia, Cmd.none )



-- what happens is that when the state transitions to toggle off a feature,
-- then only the direct `Control` properly deprecates (poof) its elements
-- whereas all the others continue to be drawn.
--
-- The reason is that we implement hiding as `wrap`, which only
-- affects the `current Aspect`!


type alias Ui =
    Ui.Ui
        Aspect
        ( String, Html () )


type alias Document =
    Restrictive.Document Aspect ( String, Html () )


view : Multimedia -> Document
view _ =
    let
        showTab : String -> Ui -> Ui
        showTab str contents =
            Restrictive.toggle (String.replace " " "-" str)
                |> Ui.with Scene contents
    in
    { body =
        Ui.with Info (Ui.textLabel "Toggle the multimedia on top of the page! ") Ui.singleton
            ++ showTab "Flat Ui Layout"
                ui
            ++ showTab "Global Navbar"
                globalNav
            ++ (Ui.handle [ ( "constant", Html.label [] [ Html.text "ConStAnt" ] ) ]
                    |> Ui.with Scene (Ui.textLabel "ConsScene")
               )
            ++ Ui.with Scene (Ui.html ( "content", main_ )) Ui.singleton
    , layout = Restrictive.Layout.withClass "Multimedia"
    , title = "Restrictive Ui feature test"
    }


{-| [Ui](Ui): Flat layout instead of nested components
-}
ui : Ui
ui =
    Ui.handle [ ( "handle", Html.label [] [ Html.text "Handle" ] ) ]
        |> Ui.with Scene (Ui.textLabel "Scene")
        |> Ui.with Control (Ui.textLabel "Control")
        |> Ui.with Info (Ui.textLabel "Info")


{-| [Application](Ui.Application): Sever Route from Model
-}
paths : Restrictive.State.Path -> Ui
paths path =
    Ui.singleton
        |> Ui.with Scene (Ui.textLabel ("Path: " ++ path))
        |> Ui.with Control (Restrictive.goTo ( Just "Path-1", Nothing ))
        |> Ui.with Control (Restrictive.goTo ( Just "Path-2", Nothing ))
        |> Ui.with Control (Restrictive.goTo ( Just "", Nothing ))
        |> Ui.with Control (Restrictive.goTo ( Nothing, Nothing ))
        |> Ui.with Control (Restrictive.goTo ( Nothing, Just "99" ))


globalNav : Ui
globalNav =
    [ "Introduction", "First Steps", "Last Steps" ]
        |> List.concatMap (\title -> Restrictive.goTo ( Just title, Nothing ))


{-| [Link](Ui.Link): Manage the Ui State as a URL
-}
fragments : Restrictive.State.Fragment -> Ui
fragments fr =
    let
        articles : List (Html msg)
        articles =
            [ Html.article [ Attr.id "1", Attr.tabindex 1 ]
                [ Html.p [] [ Html.text "Officiis tractatos at sed. Vim ad ipsum ceteros. Posse adolescens ei eos, meliore albucius facilisi id vel, et vel tractatos partiendo. Cu has insolens constituam, sint ubique sit te, vim an legimus elaboraret. Omnes possim mei et. Equidem contentiones vituperatoribus ut vel, duis veri platonem vel ei, an integre consequat democritum qui." ] ]
            , Html.article [ Attr.id "2", Attr.tabindex 1 ]
                [ Html.p [] [ Html.text "Officiis tractatos at sed. Vim ad ipsum ceteros. Posse adolescens ei eos, meliore albucius facilisi id vel, et vel tractatos partiendo. Cu has insolens constituam, sint ubique sit te, vim an legimus elaboraret. Omnes possim mei et. Equidem contentiones vituperatoribus ut vel, duis veri platonem vel ei, an integre consequat democritum qui." ] ]
            , Html.article [ Attr.id "3", Attr.tabindex 1 ]
                [ Html.p [] [ Html.text "Officiis tractatos at sed. Vim ad ipsum ceteros. Posse adolescens ei eos, meliore albucius facilisi id vel, et vel tractatos partiendo. Cu has insolens constituam, sint ubique sit te, vim an legimus elaboraret. Omnes possim mei et. Equidem contentiones vituperatoribus ut vel, duis veri platonem vel ei, an integre consequat democritum qui." ] ]
            ]
    in
    Ui.singleton
        |> Ui.with Control
            (Restrictive.bounce
                { here = ( Nothing, Just "1" ), there = ( Nothing, Just "3" ) }
            )
        |> Ui.with Scene
            (Ui.html ( "articles", Html.section [] articles ))
        |> Ui.with Info (Ui.textLabel (Maybe.withDefault "(No fragment)" fr))


{-| -}
main : Application Multimedia Msg
main =
    application
        { init = init
        , update = update
        , view = view
        }
