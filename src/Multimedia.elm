module Multimedia exposing (main, Item)

{-|

@docs main, Item

-}

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Keyed as Keyed
import Restrictive exposing (Application, application)
import Restrictive.Layout
import Restrictive.Layout.Region exposing (Aspect(..))
import Restrictive.State exposing (Flag)
import Restrictive.Ui as Ui
import Sample exposing (Sample)
import Ui exposing (Ui)


type alias Item =
    { flag : Flag
    , category : String
    , title : String
    , handle : List (Html ())
    , description : Ui
    , sample : Sample
    , info : List (Html ())
    }


markdownBody =
    """## elm-markdown 7.0.0

- Now
  - With
    - Nested
  - List
    - Support! 🎉

# 1 Esse intrata referre inter adspeximus aequora soror

## 2 Ebur iamque mecum

2 Lorem markdownum [vitae](http://minantia.io/herbis-caelumque.aspx) crines
carminibus exponit pugnax dilectaque Sparte te est. Nullos imperium! Ait qui
corpora perstat Gryneus fidem iunctura. Hic sperne inquit iuventus timidasque
iuvenis stirpe barbarus sorori? Fatebor non in iaculatur, concuteret auget
corpore accepere vectus pacisci quoque renascitur essem: frugum labentibus
Naxoque festum despectat.

## 3 Saepe nec tergo Iole te solent pharetras

3 Iamque insula, ore longe dixerat libratum neque terrarum resedit de iuranda cum
muneris *tamen*, suas populique te. Alumno invidiae cecinit exarsit modo vidit
ingentia suum, et pluribus sensu *Danais* adigitque acervo gravis visae,
capillos!

    3avar post = client_script_agp(bar_address_golden(flash, digital_halftone_unix
            + 3), supercomputer_bridge);
    type_ctr_drag(waveform, -2, core_rom);
    if (frameworkFile * wiki_ddr >= architecture_core(station_mebibyte, 5,
            dual_cd)) {
        tft.logMirror(infotainmentPram + spoofingArchitectureServer,
                sliRiscParse + mmsClean);
    }

## 4 Vetustas caede

4 Grata raucaque dixit delenda terris. Actorum circumdata fronde fuerat, accepisse
certe, haurit manu. [Ventura Achille](http://www.devolenti.net/canoro.php)
admovit, non ut tempto violas est ego pater; fit probavit iaculi Ophiusiaque
inque. Conlectae est premebat subsunt. Dum ad adusque sol sub vini, quod: per
guine, recludit posuisti: Trinacris Sibyllae.

## 5 Tamquam novus

5 Nec munera pia sequuntur consedit est vultus, **enim laeva**, hortaturque
sulphura fraterna somni [circumstantes](http://illis-vacant.io/susmater.php)?
Futurae habet visa cogit natus coeperat lacertos luxuriem, coloribus quaecumque
unus membra? Et molirique saevior terrae concubiturus pars. Aequor convivia ergo
nec salutem, absentem veris exspirat, traxit deiectoque dedignata evolat pressit
me promissa amor ardor.

5b Iuvenem fluunt populusque iterum arcet donavi testatos tellus semperque
debueram. Edidit [illo votis](http://sum.net/cumfelixque) Melicerta *vivus*,
mare, **praefoderat iubasque**? Dabat **temerarius boves orbe** populi!

## 6 Sic colitur tecum exsultantemque fessis vidit rescindere

6 Polydoreo Iovis mentis fratre posse, claudit placabilis nisi radiante premunt,
cum committitur, inquit bovem caput, vocem! De sensit vestigia super. Effugit
nux tamen nota pererrat nec semel erat: quater e solvi non nec **inmitem
tristi**.

6b Talia litore glomerataque quantum lentaque **restat**, nec lapsa Threiciis
subiere tamen exercere et tuis. Est fine cum supposito iamque, ex templa illa
cursus venerit tenebat et? Quemque mihi, dare erudit Lyncus, ab dicebar iterum
exanimi sermone; esse Iunonem paelicis mundi velit.

6c *Tydiden dubitabile neque* conscendere ardor verboque sic refert Auroram
sequantur praemia doleam pectusque fumantia hospes, cum silvaque caputque. Domat
et annis corpus est aperire amoris. Concha non quae columbas, quae tenuem,
pervia, euntis?
"""


{-| -}
main : Application (List Item) ()
main =
    application
        { init = ( items, Cmd.none )
        , update = \() model -> ( model, Cmd.none )
        , view = view
        }


items : List Item
items =
    let
        mySample : Sample
        mySample =
            Sample.Diagram
                { left =
                    [ """<more summary='Hello'>Yo I am here</more>
Incipit
<more summary='Lucha\u{00A0}Lugar'>
Description and here we have a very very long description... _so long in fact it will definitely span several lines, perhaps many..._
<more summary='Click me! I am
- several 
- lines 
- long'>
Tada!
</more>
Ciaou!!!!</more>
                            """
                    , "vide0club"
                    , "Hologram"
                    ]
                , filename = "diagram/shell.jpg"
                , alt = "Through webs of affinity, informal conversations and experiments, we research and build shells, and invite fellow activists for mentoring and mutual workshops. Our traces are shared in zines."
                , right = [ "are.na channel", "workshops", "ShellXhibition (upcoming)", "ShellXhibition (upcoming)", "And here we have a _long_ one", "ShellScape Navigator", "Congress Website (2021)", "Mentoring protocol", "instagram channel", "Boundary Layer Definition" ]
                , bottom = [ "Resources", "Discourse", "Art", "Commons", "Academia", "Funding", "Imaginaries", "Public\u{00A0}Spaces", "Infrastructure" ]
                }
    in
    [ { flag = "Shell"
      , category = "Project across many media"
      , title = "Gmhtrty y _urkutr_"
      , handle = [ Html.text "🐚" ]
      , description =
            (Sample.markdown >> Html.div [] >> Tuple.pair "description" >> Ui.html)
                """Since 2020, we are organising [Congresses and Symposiums](https://ShellCongress.com "You can read more here | Here we have all the description"), curate [a news channel](https://instagram.com/ShellCongress) and a [collection of traces and reflections](https://www.are.na/flupsi-upsi/shell-3fezyrjc5iy) and [navigate the ShellScapes](https://gather.town/app/5Wp6ebk3fOGv9Uuo/SHELL). The following diagram shows how our collective shell grew to tackle all sorts of media surfaces. Click the pink links to learn more about our activities."""
      , sample = mySample
      , info = []
      }
    , { flag = "SecondThing"
      , category = "Project across many media"
      , title = "Shell Process"
      , handle = [ Html.text "🐚" ]
      , description =
            (Sample.markdown >> Html.div [] >> Tuple.pair "description" >> Ui.html)
                """Since 2020, we are organising [Congresses and Symposiums](https://ShellCongress.com), curate [a news channel](https://instagram.com/ShellCongress) and a [collection of traces and reflections](https://www.are.na/flupsi-upsi/shell-3fezyrjc5iy) and [navigate the ShellScapes](https://gather.town/app/5Wp6ebk3fOGv9Uuo/SHELL). The following diagram shows how our collective shell grew to tackle all sorts of media surfaces. Click the pink links to learn more about our activities."""
      , sample = mySample
      , info = []
      }
    ]


viewItem : Item -> Ui
viewItem { flag, category, title, handle, description, sample, info } =
    (List.concat >> Ui.ul flag)
        [ Ui.html ( "category", Html.span [ Attr.class "category" ] [ Html.text category ] )
        , Ui.wrap (\h -> [ ( "anchor", Html.a [ Attr.href ("#" ++ flag), Attr.id flag ] [ Keyed.node "h1" [] h ] ) ]) (List.concatMap Ui.html (Sample.markdown title |> List.map (Tuple.pair "")))
        , Ui.handle (List.indexedMap (\i -> Tuple.pair (String.fromInt i)) handle)
        , description
        , Sample.view sample

        --, Ui.html ( "observe center", Html.node "focus-when-in-center" [ Attr.attribute "flag" flag ] [] )
        ]
        |> Ui.with Info (Ui.foliage (List.indexedMap (\i -> Tuple.pair (String.fromInt i)) info))


view : List Item -> Ui.Document
view items_ =
    let
        showTab : String -> Ui -> Ui
        showTab str contents =
            Restrictive.toggle (String.replace " " "-" str)
                |> Ui.with Scene contents
    in
    { body = List.concatMap viewItem items_ ++ (Sample.markdown >> List.concatMap (Tuple.pair "" >> Ui.html)) markdownBody
    , layout = Restrictive.Layout.withClass "Multimedia"
    , title = "Restrictive Ui feature test"
    }
