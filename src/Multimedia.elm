module Multimedia exposing (main)

{-|

@docs main

-}

import Content exposing (Content)
import Html exposing (Html)
import Html.Attributes as Attr
import Restrictive exposing (Application, application)
import Restrictive.Layout
import Restrictive.Layout.Region exposing (Aspect(..))
import Restrictive.State
import Restrictive.Ui as Ui


type alias Ui =
    Ui.Ui
        Aspect
        ( String, Html Content.Msg )


type alias Document =
    Restrictive.Document Aspect ( String, Html Content.Msg )


view : Content -> Document
view content =
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
            ++ Ui.with Scene (Ui.html ( "content", Content.view content )) Ui.singleton
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
main : Application Content Content.Msg
main =
    application
        { init = Content.init
        , update = Content.update
        , view = view
        }
