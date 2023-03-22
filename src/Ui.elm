module Ui exposing (Document, Ui, toggle)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Keyed as Keyed
import Restrictive as Restrictive exposing (Application, application)
import Restrictive.Get
import Restrictive.Layout
import Restrictive.Layout.Region as Region exposing (Aspect(..))
import Restrictive.Mask
import Restrictive.State exposing (Flag)
import Restrictive.Ui as Ui


type alias Ui =
    Ui.Ui
        Aspect
        ( String, Html () )


type alias Document =
    Restrictive.Document Aspect ( String, Html () )



------- Helpers -------


{-| Will add an inline text link and occlude all regions while unchecked.

    a[role="switch"]:aria-checked {}

-}
toggle : List (Html Never) -> Flag -> Ui
toggle face =
    Restrictive.State.toggle
        >> Restrictive.State.view (Restrictive.State.preset.inline [] face)
        >> (<<)
            (\{ linkHtml, occlude } ->
                Restrictive.Mask.mapKey ( Region.justRegion, Region.Region >> Just ) occlude
                    >> Restrictive.Get.append (Restrictive.Get.map Ui.foliage linkHtml)
            )
        >> Ui.custom
