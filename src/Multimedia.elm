module Multimedia exposing (main)

{-|

@docs main, Item

-}

import Restrictive exposing (Application, application)
import Restrictive.Layout
import Restrictive.Layout.Region exposing (Aspect(..))
import Restrictive.Ui as Ui
import Ui exposing (Item, Sample(..), Ui, markdown, viewItem)


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
    [ { flag = "Restrictive"
      , category = "Ui library"
      , timeframe = "2022—"
      , title = "Restrictive"
      , description =
            """
For my smaller SPA projects, I am collecting some abstractions into a UI library. I am going for <more summary="cohesion"> Aiming to concentrate everyting pertaining to a certain type inside its corresponding model. [Read the Wikipedia\u{00A0}article](https://en.wikipedia.org/wiki/Cohesion%28computer_science%29 "Wikipedia article")</more> as opposed to control.
"""
      , sample =
            Diagram
                { left =
                    []
                , filename = ""
                , alt = ""
                , right = []
                , bottom = []
                }
      , info = """
- The Url stores the complete UI state. <more summary="_How?_">In contrast to the Elm architecture, `update` and `view` don't receive the URL. Instead, you create Links such as `toggle`, `goTo`, `tab` or `bounce` to add UI state. This guarantees that when you share a link or your current URL, the receiver will get the same view.</more>
- The module hierarchy is independent from the layout. <more summary="_How?_">Write `view` functions for your types in the corresponding modules, then give them a place in the global layout. In the diagram above, you can see the default layout with four regions.</more>"""
      }
    , { flag = "Shell"
      , category = "Project across many media"
      , timeframe = "2021—"
      , title = "The Shell"
      , description =
            """
This figure inspires a growing network of activsts around the world to re-examine the <more summary="_surfaces of imagination_"> Where are body images created? Clothes, screens, sculptures, image-boards, magazines, film and genders are examples of what we call _Shells_, hybrid hulls holding collages of imaginary bodies that we edit and inhabit collectively. </more>. In workshops, congresses and virtual landscapes, we become future queer and deviant bodies."""
      , sample =
            Diagram
                { left =
                    [ """
<more summary='Hello'>Yo I am here</more>
Incipit
<more summary='Lucha\u{00A0}Lugar'>
Description and here we have a very very long description... _so long in fact it will definitely span several lines, perhaps many..._
<more summary='Click me! I am
- several 
- lines 
- long'>
Tada!
</more>
Ciaou!!!!</more>"""
                    , "vide0club"
                    , "Hologram"
                    ]
                , filename = "diagram/shell.jpg"
                , alt = "Through webs of affinity, informal conversations and experiments, we research and build shells, and invite fellow activists for mentoring and mutual workshops. Our traces are shared in zines."
                , right = [ "are.na channel", "workshops", "ShellXhibition (upcoming)", "ShellXhibition (upcoming)", "<more summary='Yes'>And here we have a _long_ one</more>", "ShellScape Navigator", "Congress Website (2021)", "Mentoring protocol", "instagram channel", "Boundary Layer Definition" ]
                , bottom = [ "Resources", "Discourse", "Art", "Commons", "Academia", "Funding", "Imaginaries", "Public\u{00A0}Spaces", "Infrastructure" ]
                }
      , info = """
Since 2020, we are organising 
[Congresses and Symposiums](https://ShellCongress.com "https://ShellCongress.com | Visit our 2021 congress website to learn more"), 
curate [a news channel](https://instagram.com/ShellCongress " | Instagram Channel with news and invitations") and 
a [collection of traces and reflections](https://www.are.na/flupsi-upsi/shell-3fezyrjc5iy " | Are.na channel") 
and [navigate the ShellScapes](https://gather.town/app/5Wp6ebk3fOGv9Uuo/SHELL " | Choose your Avatar and start exploring our interactive surface where we hold international events on gather.town"). The following diagram shows how our collective shell grew to tackle all sorts of media surfaces. Click the pink links to learn more about our activities.
"""
      }
    , { flag = "MaT"
      , category = "Community Lab Series"
      , timeframe = "2021—"
      , title = "Moving across Thresholds"
      , description =
            """For Renae Shadler's lab series, I am creating [a website/archive](https://movingAcrossThresholds.com "https://movingAcrossThresholds.com | Here, participants of the labs can browse and add traces of their explorations.") and a newsletter and social media campaign. In this video where I go through some of our considerations and decisions:"""
      , sample =
            Video
      , info = """
Renae was looking for an immersive experience that would match the topic of 'moving across thresholds': traversing fields of arts, critical theory and activism. We decided to build a giant Accordion component where visitors can open and close nested segments. The Tree-Zipper which I had implemented in 2019 was the perfect structure to hold the data. In the implementation process, we had to tackle several challenges:

- Proper date/time management that would work seamlessly in different timezones meant that the Ui would display local dates while the backend would store UTC.
- I implemented automatic linking across the segments (for example to connect the articles on events with the corresponding facilitator bios) by auto-generating a dictionary with valid links and fuzzy matching of URL paths.
- We integrated a Google Drive folder as well as an are.na channel in their own custom elements. Unfortunately, both services have a very limited Api. In contrast, the vimeo Api, an external video cover-image service, and weserv.nl for image preprocessing proved more solid for a deep integration.
- To match the idea of moving across segments, I implemented fluid animations and transitions in css, adding some custom elements where the elm architecture was too centralistic. 
      
But the larges and most interesting task was implementing a content management system with unlimited Undo. My solution is to encode the state as a series of transformations (Actions), where each edit adds to an append-only log. The `view` folds this log into a zipper (a tree with a single open node) and renders it to Html."""
      }
    , { flag = "Glossary"
      , category = "Research and sketches"
      , timeframe = "2019—20"
      , title = "Bodies experiencing virtual spaces"
      , description =
            """Since 1019, I have been conducting UX experiments with fellow artists and community organizers. How can we navigate and reclaim virtual spaces? What kind of avatar can we become there? How can we meet and organize as hybrid bodies?"""
      , sample =
            Diagram
                { left = []
                , filename = "glossary.svg"
                , alt = "UX research"
                , right = []
                , bottom = []
                }
      , info = """m"""
      }
    , { flag = "bombast"
      , category = "Multilingual website"
      , timeframe = "2018"
      , title = "Bombast Duo"
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
    , { flag = "weise"
      , category = "Virtual copy of an interactive artwork"
      , timeframe = "2018"
      , title = "Die Weisen"
      , description =
            """With artist Stephanie Hannah, I created a virtual copy of her Aduino-powered speaking suitcase. Click the buttons to hear people interviewed Berlin neighborhoods tell you what they consider a good life (German-language)"""
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
    let
        showTab : String -> Ui -> Ui
        showTab str contents =
            Restrictive.toggle (String.replace " " "-" str)
                |> Ui.with Scene contents
    in
    { body = List.concatMap viewItem items_
    , layout = Restrictive.Layout.withClass "Multimedia"
    , title = "Restrictive Ui feature test"
    }
