module Multimedia exposing (main)

{-|

@docs main, Item

-}

import Less
import Less.Ui as Ui
import Less.Ui.Html as Html exposing (Region(..), layout)
import Ui exposing (Item, Sample(..), Ui, viewItem)


{-| -}
main : Less.Application (List Item) ()
main =
    Less.application
        { init = ( items, Cmd.none )
        , update = \() model -> ( model, Cmd.none )
        , view = view
        }


items : List Item
items =
    [ { fragment = "Less"
      , category = "Ui library"
      , timeframe = "2022—"
      , title = "Less"
      , description =
            """
For my smaller SPA projects, I have collected a few useful UI patterns into a library, priorizing <more summary="cohesion"> 
 Aiming to concentrate everyting pertaining to a certain type inside its corresponding model. [Read the Wikipedia\u{00A0}article](https://en.wikipedia.org/wiki/Cohesion%28computer_science%29 "Wikipedia article")</more> 
and defaults at the expense of power and expressiveness. This is my first open-source library 🐬

- _Defaults:_ The URL stores the complete UI state. <more summary="_How?_">In contrast to the Elm architecture, `update` and `view` don't receive the URL. Instead, you add predefined Links such as `toggle`, `goTo`, `tab` or `bounce` to differenciate UI (sub)states. This guarantees that when you share a link or your current URL, the receiver will get the same view.</more>
- _Cohesion:_ The module hierarchy is independent from the layout. <more summary="_How?_">Write `view` functions for your types in the corresponding modules, then give them a place in the global layout. In the diagram below, you can see the default layout with four regions.</more>
"""
      , sample =
            Diagram
                { left =
                    [ """
<more summary="`Handle` Region <alternate/>">Tabs, toolbars menus...</more>"""
                    , """
<more summary="`Scene` Region <alternate/>">The composition that a user can view, edit and share</more>"""
                    , """"""
                    , """"""
                    , """
<more summary="`Control` Region <alternate/>">
The editing controls are automatically derived from the model (w.i.p.)</more>"""
                    ]
                , center = """

<over lays='

11.13rem 0.5rem 0deg Toggling 
<highlight/>

+++ 8.3rem 10.45rem 0deg Code  
<highlight/>

+++ 8.3rem 17.13rem 0deg Code1 
<highlight/>

+++ 8.3rem 21.4rem 0deg Code2 
<highlight/>

+++ 5rem 26.26rem 0deg Progressive 
<highlight/>

+++ 11.133rem -4.96rem 0deg Progressive1 
<highlight/>

'>
![](less.png)

</over>

"""
                , right =
                    [ """
URL: <url>x.y<more summary="/Comp1#square">`Path` and `Fragment` determine which page to show and which object to focus.</more><more summary="?edit">A `Flag` may reveal the editing controls.</more></url>"""
                    , """
<more summary="Toggling the UI state" >This eye icon might toggle the visibility of a layer. But since the view-state is kept inside the URL, I don't need to pass messages and Booleans across modules in my `update`.</more>"""
                    , """"""
                    , """
<more summary="Code Cohesion"> A single `view` can span several screen regions. No need to manually pass fragments across modules. This square is represented as a shape in the `Scene`, its comments are accessible in an `Info` bubble, and its data is editable through the property sheet in the `Control` region.</more>"""
                    , """"""
                    , """"""
                    , """
<more summary="`Info` Region <alternate/>">Toasts, popups...</more>"""
                    , """"""
                    , """"""
                    , """"""
                    ]
                , bottom = [ """
<more summary="Progressive Disclosure">By clicking `OK`, you toggle the `edit` flag from the URL, which in turn determines the visibility of the Control Sheet. Such `toggle` links can be nested to implement deep [progressive disclosure](https://www.nngroup.com/articles/progressive-disclosure/).</more>""" ]
                }
      , info = """
- [Visit my `restrictive` github repo](https://github.com/upsiflu/less-ui)
- [Use the stable version of the library](https://package.elm-lang.org/packages/upsiflu/less-ui/latest)
- [Check out the demo, a self-explaining walkthrough](https://less-ui.web.app/)
      
I implemented the clickable headings on this page using my `Less` library. [Browse the Source here](https://github.com/upsiflu/multimedia)"""
      }
    , { fragment = "Shell"
      , category = "Project across many media"
      , timeframe = "2021—"
      , title = "The Shells"
      , description =
            """
This figure inspires a growing network of activsts around the world to re-examine the <more summary="_surfaces of imagination_"> Where are body images created? Clothes, screens, sculptures, image-boards, magazines, film and genders are examples of what we call _Shells_, hybrid hulls holding collages of imaginary bodies that we edit and inhabit collectively. </more>. In workshops, congresses and virtual landscapes, we become future queer and deviant bodies."""
      , sample =
            Diagram
                { left =
                    [ """"""
                    , """
![Lucha](shell-2.png)

<more summary='Lucha\u{00A0}Lugar '>
<alternate/>

Under the calcic guise of academic research, Michelle and Padme are practicing imagination against the genocide, inspired by the Zapatista maxim 'Lucha como Lugar' (The struggle is a place). Fighting against the hegemony of extractivism, our colonised bodies are in diverse situations and frontlines, but the struggle connects in a shared imaginary.

</more>

"""
                    , """

![vide0club](shell-0.png)

                    
<more summary='vide0club'>
<alternate/>

Valki's vide0club events support filmmakers creating anti-hegemonial queer and third-world body images. How can we leverage the peculiarities video and film to step out of the colonial matrix of representation?

</more>
"""
                    , """
![Hologram](shell-1.png)
                    
<more summary='Hologram'>
<alternate/>

The Hologram is an international communit of activists, as well as a protocol for mutual care. As a Shell, it leverages the power of asking friends for support, building a resourceful militia as capitalism crumbles.

</more>
"""
                    , """"""
                    , """"""
                    , """"""
                    ]
                , center = """<over lays=

'10.666rem 0.66rem -45deg Research 
Shell Research 

+++ 12.66rem 7rem -40deg Wearable 
Wearable Shells

+++ 8rem 20rem -85deg Webs 
What we do

+++ 15.66rem 15rem -22deg Traces 
Collecting traces

+++ 17rem 24rem -3deg Congresses 
Congresses

+++ 16rem 33rem 20deg Mentoring 
Mentoring

+++ 14.76rem 39rem 30deg Call 
Open Call

+++ 0rem 37rem 0deg HCO3 
![HCO3](HCO3.png) 

+++ 5.33rem 39.666rem 0deg Ca 
![Ca](Ca.png)
'>



![Through webs of affinity, informal conversations and experiments, we research and build shells, and invite fellow activists for mentoring and mutual workshops. Our traces are shared in zines.](clamshell.png)
</over>"""
                , right =
                    [ """
![icon](arena.png)
[Virtual Wunderkammer](https://www.are.na/flupsi-upsi/shell-3fezyrjc5iy "Research | Browse our Are.na channel")"""
                    , """
![icon](workshop.png)
[Workshop series](https://docs.google.com/document/d/e/2PACX-1vQrtVZQEc9QHKuutcXynNZCqoDP9UnomuEkwbghRHjgYg23kE5ATUpGD0tHlaurPRuAxQmngfkBwfRg/pub "Congresses Wearable Traces | In this workshop series, I am inviting participants to engage with their individual boundaries, develop an awareness for the simultaneous Shells around our bodies, and then build a collective exosceleton")"""
                    , """
![icon](shellscape.png)
[ShellScape Navigator](https://gather.town/app/5Wp6ebk3fOGv9Uuo/SHELL "Congresses Traces | Choose your Avatar and start exploring our interactive surface where we hold international events on gather.town")"""
                    , """
![icon](portal.png)
[Congress Website](https://ShellCongress.com "Congresses Mentoring | Visit our 2021 congress website to learn more") """
                    , """
![icon](mentoring.png)
[Mentoring protocol](https://www.are.na/block/18602679 "Mentoring Congresses | Clara and I developed a protocol for mentoring the contributors to the Congresses")"""
                    , """
![icon](instagram.png)
[Image Stream](https://instagram.com/ShellCongress "Call Congresses | Instagram channel with news and invitations")"""
                    ]
                , bottom = [ "Resources", "Discourse", "Art", "Commons", "Academia", "Funding", "Imaginaries", "Public\u{00A0}Spaces", "Infrastructure" ]
                }
      , info = """"""
      }
    , { fragment = "MaT"
      , category = "Community Lab Series"
      , timeframe = "2021—"
      , title = "Moving across Thresholds"
      , description =
            """For Renae Shadler's lab series, I am creating a website/archive and a newsletter and social media campaign. In this video I walk through some of our considerations and decisions:"""
      , sample =
            Carousel "MaT"
                [ """![](mat-layout.png)
<more summary="Layout Draft">Inspired by the Accordion widget and progressive disclosure, I drafted a layout that would nudge the visitor to scroll in order to explore the depths and breadths of the _Moving across Thresholds_ project.</more>
"""
                , """![](mat-design-1.png)"""
                , """![](mat-design-2.png)
<more summary="Responsive design">Any screen, even the narrowest, will display at least one column of text, and hint at content that exists in either cardinal direction. We defined a column as 21rem so that the most common phone screens present text at 15-16px. On narrower screen, the rem decreases progressively.</more>
"""
                , """![](mat-screen-3.png)
<more summary="Result">This is how the it turned out. I removed lots of shades and lines to reduce visual noise as the site is quite picture-heavy.</more>  
"""
                , """![](mat-screen-2.png)"""
                , """![](mat-screen-1.png)
                
<more summary="Community interaction">The site integrates our `Are.na` library of texts as well as out Google drive where everyone is invited to leave and edit the traces from the labs.</more>                
"""
                , """![smooth](mat-flows.png)
                
<more summary="Data flows">This diagram is my attempt at visualizing sources of truth for the application, and how they interrelate. On the web platform, it seems impossible to have a single source of truth since we are at least dealing with the URL, the open page in the tab (with scroll, text-zoom, pinch-zoom, locale, navigation history), DOM (including the Focus), and the database, in this case a very simple firestore with hypertexts for articles and an append-only log for the site structure and non-HTML data.</more>        
"""
                ]
      , info = """
[Renae](http://renaeshadler.com/about/ " | Berlin-based choreographer, performer and researcher exploring how we are both shaping and being shaped by our environment &#91;website&#93;") was looking for an immersive experience that would match the topic of 'moving across thresholds': traversing fields of arts, critical theory and activism. We decided to build a giant Accordion component where visitors can open and close nested segments. <more summary="The Tree-Zipper which I had implemented in 2019">![](zippers.jpg)[Browse the code on github](https://github.com/upsiflu/matsite/tree/main/src/Zipper) </more> was the perfect structure to hold the data. In the implementation process, we had to tackle several challenges:

- Robust <more summary="date/time management"> The UI would display local dates while the backend would store UTC. </more>
- <more summary="Fluid animations and transitions in css \u{00A0} "> I added custom elements where the centralism of the Elm architecture seemed unnecessary. </more> \u{00A0} to match the idea of moving across segments.
-  Automatic <more summary="linking across the segments"> (for example to connect the articles on events with the corresponding facilitator bios) by auto-generating a dictionary with valid links and fuzzy matching of URL paths.</more>
- <more summary="Integrating a Google Drive folder as well as an are.na channel"> Unfortunately, both services have a very limited Api. In contrast, the vimeo Api, an external video cover-image service, and weserv.nl for image preprocessing proved more solid for a deep integration.</more> in their own custom elements.
      
But the larges and most interesting task was implementing <more summary="a content management system with unlimited Undo."> My solution is to encode the state as a series of transformations (Actions), where each edit adds to an append-only log. The `view` folds this log into a <more summary="Zipper">A tree datastructure with a single "open" node</more> and renders it to Html.</more>

[Visit the website where lab participants can browse and add traces of their explorations](https://movingAcrossThresholds.com)"""
      }
    , { fragment = "Glossary"
      , category = "Research"
      , timeframe = "2018—21"
      , title = "Bodies experiencing virtual spaces"
      , description =
            """
In various UX experiments with fellow artists and community organizers, we examined: How to navigate and reclaim the platforms? What creative opportunities lie behind the UIs? Which hybrid body shells help us organize collective political action against barriers and policing?
"""
      , sample =
            Carousel "Ux"
                [ """![](ux-tests.jpg)

<more summary="Exploring virtual collage surfaces...">![](ux.gif)
<more summary=" User interface investigation with Sabrina...">
 Exploring an exhibition she created on the platform ResearchCatalogue.net, we are recording the barriers she encounters as she navigates and edits the multi-media collage. How does my body expand into the boundaries set by the software? Which strategies and tactics help me find agency and discover new possibilities? How does the experience affect my self-image and my self-awareness irl?
</more>
</more>"""
                , """
![](selfreplacement.jpg)

<more summary="Self Replacement!">
In her workshop “On identities, Other(s) Ours’ cartography” on the final day of the first ShellCongress (2021), [Yarinés Suarez](https://shellcongress.com/?window=Yarin----s-Suarez) invited us to map our many identities and intersection on a shared virtual canvas.

This collage from our zine <more summary="captures identity as a collage of simultaneous media fragments: user interface elements, avatars, video frames, chat messages, multi-user doodles">
Who is ‘we’, who addresses ‘us’, what is beyond ‘this’ body? Rituals on coded surfaces temporarily change our bodies. Avatars, roles and personas then shellter us from impositions of fixed identity, and reciprocally shellter those who address us from an encounter with the messy mollusc of what’s behind the mask — something that may not ‘really’ exist.</more>. You can [take a tour of the ShellScape here](https://www.are.na/flupsi-upsi/shell-3fezyrjc5iy).

</more>"""
                , """

![](controls.png)"""
                , """

![](ui-design.jpg)"""
                ]
      , info = """[Read my Glossary of UX concepts &#91;pdf&#93;](UX-Glossary.pdf)"""
      }
    , { fragment = "Bombast"
      , category = "Multilingual website"
      , timeframe = "2018"
      , title = "Bombast Duo<single-column/>"
      , description =
            """With performance duo Bombast, I created a website template. Since the clients know HTML, we eschew a CMS or a build system in favor of a straightforward single-page HTML file."""
      , sample =
            Inclusion
                { left = [ "\u{00A0}" ]
                , source = "https://bombastDuo.com"
                , right = []
                , bottom = []
                }
      , info = """
Kasia and Elena speak four languages, so I created a language switcher that simply toggles the visibility of paragraphs based on the chosen language, with a fallback to english.
      
After more than five years, this site has never needed maintenance.

[Check out the Duo's website in a new tab](https://www.stephaniehanna.de/wp-content/weiseapp2018/weiseapp.html)"""
      }
    , { fragment = "Weise"
      , category = "Virtual copy of an interactive artwork"
      , timeframe = "2017"
      , title = "Die Weisen<single-column/>"
      , description =
            """With artist [Stephanie Hannah](https://www.stephaniehanna.de/en/about-en/ " | Here's her website"), I created a virtual copy of her Arduino-powered speaking suitcase. Click the buttons to hear people interviewed Berlin neighborhoods tell you what they consider a good life (German-language)"""
      , sample =
            Inclusion
                { left = [ "\u{00A0}" ]
                , source = "https://www.stephaniehanna.de/wp-content/weiseapp2018/weiseapp.html"
                , right = []
                , bottom = []
                }
      , info = """
This was my first Javascript-only animation project, and it was a fun and satifying job because the artwork is touching, the scope was very clear, and I had the resources to document and test the source code thoroughly and to learn so many things.

[Open the interactive animation in a new tab](https://www.stephaniehanna.de/wp-content/weiseapp2018/weiseapp.html)"""
      }
    ]


view : List Item -> Ui.Document
view items_ =
    { body =
        Ui.viewHeading ++ Ui.inRegion Scene (List.concatMap viewItem items_)
    , layout =
        { layout
            | arrange = Ui.arrangeOverDefaultRegions
        }
    , title = "Flupsi's multimedia portfolio"
    }
        |> Less.mapDocument identity
