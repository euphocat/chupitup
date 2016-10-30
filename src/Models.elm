module Models exposing (..)

import Routing.Routes exposing (Route)
import Set
import Helpers.Tags exposing (Tag)


type alias Url =
    String


type alias Article =
    { id : Int
    , title : String
    , description : String
    , body : String
    , photoThumbnail : Url
    , tags : List Tag
    , place : Tag
    }


type alias State =
    { route : Route
    , articles : List Article
    , tags : List Tag
    , visibleTags : Set.Set Tag
    , visiblePlaces : Set.Set Tag
    }


newState : Route -> State
newState route =
    { route = route
    , articles =
        [ { id = 1
          , title = "Le Francois 2"
          , description = "L'adresse ultime à Coueron. Il reste notre endroit incontournable et pourtant il n'est pas si connu !"
          , body = """
## Despicit potest apertos tamen hostis pilas teneri

Lorem markdownum versato germana **sustinet** Pittheus, voces voce vincula,
petentes? *Sortita caput suspiria* nate, est sustinet auctor **pondus claudit
separat** Perseus mirum animae dextra iacentes.

- Magna nudo quo viribus utere
- Illa dabo ferarum elige
- Praefert animus
- Qui quos moenibus currus
- Galeae veluti rostris
- Cumque cervus una raptam quod cursu coronat

Iuppiter emittite nova puppe et partibus et flentem fertur, quae [recusat
serpunt](http://www.contigit.org/findit). Undas proxima; *ostendit* proceres
forti Erysicthonis inponit. Sint nec in quod.

## Suam tremens detraxit at placet vaccae

Viro et eram custos cessura Latia factorum labefactaque qua nec iuga aevo
chlamydem, sed latrator. Quem Latoius Nec non Periclymeni mille: toto: facie
*sua*. Erat hirsutaque velocibus semine est deae exiguo. Prosunt ex sibi bis
ferarum tellus et Titan, ait Iovi Thaumas, et! Meminit de vidit quem coeperunt
dumque pennas; ut oscula!

Mitissima incepto putat nox tempora quidem remoraminaque vaccae abiit procubuit
cogor superest quoniam pariterque seque, et causam. Ramumque recessit *euntes*
saepe, piaeque sub saeviat frustra undis. Achaemeniden tristia es freta,
pariterque in vires! Ferro sibi effugit Tenedonque si Caeneus denegat Aeacidae
procul ab delectat cognataque magna, illam Telamonius nimium **ut** virginei
nodus.

> In aethera ante deus vulneris alias, cum et Proetidas ibat. **Quas suis**.
> Donec memorare sic: altera **hanc**, est Phaethon memor ut diximus secundo
> terra, per sic viderat trahens. Cur modo sacrifica lassaque corpus hostesque
> litora cupit fine, opem in. Quam inpono, est Tantale alatur tegumenque quibus
> Tartara sorsque [dilecta](http://quipostquam.org/ferarumserta.php) orbus; iam
> sed sunt [quaeque hora](http://festamiserabile.com/utendumaetas).

Laedere enim aspicite: non nec extimuit credens iuveni quidem est aurum; in. Sub
sertaque seque at utroque semine constiterat paulatim tibi vires inhonorati,
lacertos pallescere. [Dicere](http://www.aratri-irin.io/) auras an cur non
praesignis adverso ex ante solitaeque, umerique trepidum. Vidi rexit moriturus
videri, residant amnesque usa facit, cruori spinae, patrios Pyraethi levat
calcataque foliis. Ingratos Nyctimene vosne.
          """
          , photoThumbnail = "http://www.institut-nignon.com/images/tele/francois-2-cours-2979.jpg"
          , tags = [ "restaurant" ]
          , place = "Environs de Nantes"
          }
        , { id = 2
          , title = "Le Baroque"
          , description = "Envie d'un endroit sympa au Hangar à Bananes ? Une équipe de choc et un cadre superbe."
          , body = "Empty body"
          , photoThumbnail = "http://www.hangarabananes.fr/wp-content/uploads/photo2-553x368.jpg"
          , tags = [ "bar" ]
          , place = "Hangar à Bananes"
          }
        , { id = 3
          , title = "Jo le Boucher"
          , description = "Atlantis grand lieu de la consomation. Un restaurant de chaine mais aussi une bonne surprise"
          , body = "Empty body"
          , photoThumbnail = "https://media-cdn.tripadvisor.com/media/photo-s/07/83/cb/50/jo-le-boucher-tout-un.jpg"
          , tags = [ "atlantis" ]
          , place = "Atlantis"
          }
        , { id = 4
          , title = "Le Vaporetto"
          , description = "Trentemoult et ses couleur et son restaurant italien. Quel rapport ? Aucun fils unique."
          , body = "Empty body"
          , photoThumbnail = "http://www.videgrenier-trentemoult.fr/partenaires/LeVaporetto.jpeg"
          , tags = [ "restaurant" ]
          , place = "Trentemoult"
          }
        ]
    , tags = [ "restaurant", "bar", "atlantis" ]
    , visibleTags = Set.empty
    , visiblePlaces = Set.empty
    }
