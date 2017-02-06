# elm-taco-donut

## Highly Opinionated Re-Write of **elm-taco**

After making the `elm-donut-tutorials`, I decided to take a deep-dive into `elm-taco`, a pattern for "building larger Single-Page Applications (SPAs) in Elm 0.18".

After spending a few hours looking at it, I realized I totally disagreed with the entire concept of `elm-taco`, and also realized that this seems to be a common pattern with folks writing about 'big apps' in Elm: **the impulse is to make a hierarchy of nested components**. This makes sense as many folks are coming from things like React and (more recently) Vue.js, etc. which follow this model.

I would go so far as to say this is an anti-pattern for Elm, and it looks like this:

```
Parent (model, messages, data, view, update, commands)
  -> Child (childmodel, childmessages, childdata, childview, childupdate, childcommands)
    -> SubChild (subchildmodel, subchildmessages, subchilddata, subchildview, subchildupdate, subchildcommands)
      -> SubSubChild (subsubchildmodel, subsubchildmessages, subsubchilddata, subsubchildview, subsubchildupdate, subsubchildcommands)
```

I believe this 'nested component' paradigm of organization fights TEA (The Elm Architecture) and makes for code that is difficult to maintain, write and comprehend.

## Elm Taco The Second: **elm-taco-donut**

> To run, either use `elm reactor` or if you have `elm-live` installed, just type `npm run live`

Obviously, dive in to the source code, but here's the concept.

At a high level, it strikes me that all Elm apps have the same basic functional requirements and could potentially be broken down as follows:

1. **Models**: types and records that maintain state information: the `model`.
2. **Messages**: in order to update the `model`, you must do that via a message, typically called `Msg`.
3. **Data**: specify api data structures and how to decode them.
4. **Commands**: all side-effects go here, e.g. actually fetching data from an api, running a task, etc.
5. **Init Phase**: before you can use the app, you need to initialize it to a known state.
6. **Update**: all updates to the `model` are handled here
7. **View**: views simply take the `model` and render a reactive `view` based on the model.
8. **Subscriptions**: usually, this wouldn't need to be a separate file, but could be if required.
9. **Program**: wire the app up.

Note that this is different from many Elm examples you see on the web where folks have files like 'Types.elm' that contain all of the `type` definitions (e.g. Models, Message Data and random types used by other function all lumped together), or a master file named 'Thing.elm' that contains models, messages, data, commands, updates and view functions all in one file related to a 'Thing'.

**The goal here is to break an Elm app along 'functional lines' as opposed to 'component lines'**

For a super simple app, you could make these eight files and be done, e.g.:

```
A_Model.elm
B_Message.elm
C_Data.elm
D_Command.elm
E_Init.elm
F_Updates.elm
G_Views.elm
Main.elm     
```
where Main.elm might look something like:

```Elm
module Main exposing (main)

import Navigation
import Time exposing (Time)
import A_Model exposing (Model)
import B_Message exposing (Msg(TimeChange, UrlChange))
import E_Init exposing (init)
import F_Update exposing (update)
import G_View exposing (view)


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Time.every Time.second TimeChange
        }

```

Typically, however, views get fairly hairy quickly, so maybe break those off:

```
Views/
    Page/
        Home.elm            <-- view helper (pure function, no local state!)
        OtherPage.elm       <-- view helper (pure function, no local state!)
    Widget/
        WidgetOne.elm       <-- view helper (pure function, no local state!)
        WidgetTwo.elm       <-- view helper (pure function, no local state!)
A_Model.elm
B_Message.elm
C_Data.elm
D_Command.elm
E_Init.elm
F_Updates.elm
G_View.elm                  <-- view entry point
Main.elm     
```

The next level of complexity would be to break up the `update` function:

```
Updates/
    WidgetOne.elm           <-- update helper function
    WidgetTwo.elm           <-- update helper function
    Home.elm                <-- update helper function
    OtherPage.elm           <-- update helper function
Views/
    Page/
        Home.elm            <-- view helper (pure function, no local state!)
        OtherPage.elm       <-- view helper (pure function, no local state!)
    Widget/
        WidgetOne.elm       <-- view helper (pure function, no local state!)
        WidgetTwo.elm       <-- view helper (pure function, no local state!)
A_Model.elm
B_Message.elm
C_Data.elm
D_Command.elm
E_Init.elm
F_Updates.elm               <-- update entry point
G_View.elm                  <-- view entry point
Main.elm    
```

& etc.

The reason for the letter naming (e.g. A_, B_) is that I find it easy to work sequentially either from top to bottom or in reverse from bottom to top.

"Fist, let's add to the model. Now let's add any messages. Do we need anything in Data or Command? No? Okay, add to Init. Now add the update. Finally, make the view." Etc.


# Spreadsheet, not a database!

Conceptually, I look at the `model`, `Msg` and `update` as a spreadsheet. Meaning, it's okay to have a lot of stuff in them, even at the top level. There is nothing 'wrong' with a model that looks like this:

```Elm
type alias Model =
    { appState : AppState
    , location : Location
    , taco : Taco
    , selectedLanguage : Language
    , route : Route
    , home : HomeModel
    , donuts : List DonutModel
    , pageOne : PageModelOne
    , pageTwo : PageModelTwo
    , pageThree : PageModelThree
    , pageFour : PageModelFour
    , pageFive : PageModelFive
    , pageSix : PageModelSix
    ...
    , pageSixHundred : PageModelSixHundred
    , widgetOne : List WidgetModelOne
    , widgetTwo : List WidgetModelTwo
    , widgetThree : List WidgetModelThree
    , widgetFour : List WidgetModelFour
    , widgetFive : List WidgetModelFive
    , widgetSix : List WidgetModelSix
    ...
    , widgetTwentySix : List WidgetModelTwentySix
    }
```

**There is no need to fully 'embed' a component inside another component.**

Often, within a `view` or an `update` function, you want to either look at or change part of the model that may not "belong" to the thing you are working on. Great! That's why we have one big `model`! We can just refer to using dot notation. If I am in a view that mainly uses, say, `model.pieChart`, I can still happily refer to `model.thing.otherthing.globaldatathing` and not be concerned I am going to break something somewhere else! Remember, the `model` is immutable! **It is impossible to mess this up!**

Back to the spreadsheet metaphor, using 'components' or 'parent-child-subchild' model with Elm is like trying to embed a spreadsheet inside the of a cell of an existing spreadsheet. Super bad idea.

Also, it makes it soooooooooo simple if you don't!

Rules:

1. All `views` have the same signature: `Model -> Html Msg`. All views take *the* model and return an Html Msg.
2. All `updates` have the same signature: `Msg -> Model -> ( Model, Cmd Msg )`. All updates take a message + the model, and return a tuple of (model, command)
3. All `commands` have the same signature: `Cmd Msg`
4. If you want to use a sub-thing, (e.g. sub-view, sub-update or sub-command), that's fine, but it still must return the same return type as above.

Example Update Helper:

```Elm
type Msg
    = Lots
    | Of
    | Main
    | Messages
    | Go
    | Here
    | Child ChildMsg


type ChildMsg
    = UpdateName String
    | AddCounter
    | ResetCounter


type alias Model =
    { child : ChildModel
    ...
    }


type alias ChildModel =
    { counter : Int
    ...
    }

-- main update funtion
update : Msg -> Model -> (Model -> Cmd Msg)
update msg model =
    case msg of
        Child childMsg ->
            ( updateChild childMsg model, Cmd.none )

        ...

-- child update function
updateChild : ChildMsg -> Model -> Model
updateChild childMsg model =
    let
        resetCounter child =
            { child | counter = 0 }
    in
        case childMsg of
            ResetCounter ->
                { model | child = resetCounter model.child }

            ...
```

Bonuses:

1. By having all messages handled by a single, top level `update` function (that can have update helper functions), you can avoid using `_` wildcard matches. This lets the compiler help you ensure that you've made **exactly one response for every possible message**.
2. It is very easy to reuse messages through the app. For example, any page can send any message it wants without having to wire a convoluted mechanism to do so. So if you have a `logout` button, you can stick it anywhere and not worry that it can cause a problem somewhere else. And if you do break something, the Elm compiler tells you how to fix it!

I believe the instinct to componentize comes from the brittleness of typical software.

> "Hey, this main thing works! Please, don't touch it! Maybe write a component, tell me how to access it, and I can stick it somewhere, but just don't touch the main code!" -- Lead Developer to New Hire

Typically, refactoring is terrifying and cognitively very taxing. More often than not, it's just easier to start from scratch than try & re-shape someone else's code.

With Elm, refactoring is a joy. I rebuilt `elm-taco` in an evening. The first time it compiled, it worked identically to the old `elm-taco`. I'd have much more confidence with an Elm app that just compiles, with no test coverage at all, vs. a React/Vue.js/Etc. app with tons of tests.

## Back to elm-taco-donut

In the version here, I am using the file structure as outlined above.

For the sake of show, I moved `update` to a separate folder. Personally, I would leave it 'flat' until the level of complexity got much higher, but since this is a model of how to scale apps, here you go.

I also added a component from the `elm-donut-tutorial` just for fun.

## The Larger Goal

One of the biggest challenges to software reuse lies in the difficult of figuring out what someone else has done.

Ultimately, in the same way `elm-format` rocks (which should be part of the elm core distribution, in my opnion), I am hoping to get something similar for Elm app patterns. Right now, when you looks at someone else's Elm code, the first thing you have to do is map The Elm Architecture:

```
Models
Messages
Data
Commands
Init
Updates
Views
Subscriptions
```

to whatever they have done. Did they stick the `model` in that `Types.elm` file? Or in that file called `Global.elm`? Or maybe they baked it into the `init` function, where ever that is... Or maybe they have scattered it around in each component? Etc.

So why not cut to the chase and write the code that way to begin with?

By following this convention, there is no hunting around. No sleuthing.

Also, it makes onboarding new developers a breeze, as they already know what is in each file, and where to look if they need to add or update something. Need to tweak the thing that gets data from an API? Hey, that's a command! So look in `D_Command.elm`. Also, maybe the format of the API data changed. So update `C_Data.elm` as well. And if that breaks any of the views or updates, the Elm compiler will tell you! Yippee!

We'll see!

Peace and ❤️

PS I'm sure Ossi and Matias (authors of the original `elm-taco`) are better programmers than me, so hopefully they aren't offended by this! Finland rocks!

Here is the README from the original `elm-taco`.


---

---

---

---


## :taco: Taco :taco:


This repository serves as an example for building larger Single-Page Applications (SPAs) in Elm 0.18. The main focus is what we call the _Taco_ model. Taco can be used to provide some application-wide information to all the modules that need it. In this example we have the current time, as well as translations (I18n) in the taco. In a real application, you would likely have the current logged-in user in the taco.

### Why the name?

We wanted to avoid names that have strong programming related connotations already. According to [Wikipedia](https://en.wikipedia.org/wiki/Taco):

> A taco is a traditional Mexican dish composed of a corn or wheat tortilla folded or rolled around a filling. A taco can be made with a variety of fillings, including beef, pork, chicken, seafood, vegetables and cheese, allowing for great versatility and variety.

What we mean by taco is also a vessel for tasty fillings, allowing for great versatility and variety. Plus, taco is short and memorable.


## What's the big :taco: idea?

Oftentimes in web applications there are some things that are singular and common by nature. The current time is an easy example of this. Of course we could have each module find out the current time on their own, but it does make sense to only handle that stuff in one place. Especially when the shared information is something like the translation files in our example app, it becomes apparent that retrieving the same file in every module would be a waste of time and resources.

How we've solved this in Elm is by introducing an extra parameter in the `view` functions:

```elm
view : Taco -> Model -> Html Msg
```

That's it, really.

The Taco is managed at the top-most module in the module hierarchy (`Main`), and its children, and their children, can politely ask for the Taco to be updated.

If need be, the Taco can just as well be given as a parameter to childrens' `init` and/or `update` functions. Most of the time it is not necessary, though, as is the case in this example application.


## How to try :taco:

There is a live demo here: [https://ohanhi.github.io/elm-taco/](https://ohanhi.github.io/elm-taco/)

To set up on your own computer, you will need `git` and `elm-reactor` 0.18 installed.

Simply clone the repository and start up elm-reactor, then navigate your browser to [http://localhost:8000/index.html](http://localhost:8000/index.html). The first startup may take a moment.

```bash
$ git clone https://github.com/ohanhi/elm-taco.git
$ cd elm-taco
$ elm-reactor
```


## File structure

```bash
.
├── api                     # "Mock backend", serves localization files
│   ├── en.json
│   ├── fi-formal.json
│   └── fi.json
├── elm-package.json        # Definition of the project dependencies
├── index.html              # The web page that initializes our app
├── README.md               # This documentation
└── src
    ├── Decoders.elm            # All JSON decoders
    ├── I18n.elm                # Helpers for localized strings
    ├── Main.elm                # Main handles the Taco and AppState
    ├── Pages
    │   ├── Home.elm                # A Page that uses the Taco
    │   └── Settings.elm            # A Page that can change the Taco
    ├── Routing
    │   ├── Helpers.elm             # Definitions of routes and some helpers
    │   └── Router.elm              # The parent for Pages, includes the base layout
    ├── Styles.elm              # Some elm-css
    └── Types.elm               # All shared types
```


## How :taco: works

### Initializing the application

The most important file to look at is [`Main.elm`](https://github.com/ohanhi/elm-taco/blob/master/src/Main.elm). In this example app, the default set of translations is considered a prerequisite for starting the actual application. In your application, this might be the logged-in user's information, for example.

Our Model in Main is defined like so:

```elm
type alias Model =
    { appState : AppState
    , location : Location
    }

type AppState
    = NotReady Time
    | Ready Taco Router.Model
```

We can see that the application can either be `NotReady` and have just a `Time` as payload, or it can be `Ready`, in which case it will have a complete Taco as well as an initialized Router.

We are using [`programWithFlags`](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html#programWithFlags), which allows us to get the current time immediately from the [embedding code](https://github.com/ohanhi/elm-taco/blob/36a9a12/index.html#L16-L18). This could be used for initializing the app with some server-rendered JSON, as well.

This is how it works in the Elm side:

```elm
type alias Flags =
    { currentTime : Time
    }

init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    ( { appState = NotReady flags.currentTime
      , location = location
      }
    , WebData.Http.get "/api/en.json" HandleTranslationsResponse Decoders.decodeTranslations
    )
```

We are using [`ohanhi/elm-web-data`](http://package.elm-lang.org/packages/ohanhi/elm-web-data/latest) for the HTTP connections. With WebData, we represent any data that we retrieve from a server as a type like this:

```elm
type WebData a
    = NotAsked
    | Loading
    | Failure (Error String)
    | Success a
```

If you're unsure what the benefit of this is, you should read Kris Jenkins' blog post: [
How Elm Slays a UI Antipattern](http://blog.jenkster.com/2016/06/how-elm-slays-a-ui-antipattern.html).


Now, by far the most interesting of the other functions is `updateTranslations`, because translations are the prerequisite for initializing the main application.

Let's split it up a bit to explain what's going on.


```elm
case webData of
    Failure _ ->
        Debug.crash "OMG CANT EVEN DOWNLOAD."
```

In this example application, we simply keel over if the initial request fails. In a real application, this case must be handled with e.g. retrying or using a "best guess" default.


```elm
    Success translations ->
```
Oh, jolly good, we got the translations we were looking for. Now all we need to do is either: a) initialize the whole thing, or b) update the current running application.

```elm
        case model.appState of
```
So if we don't have a ready app, let's create one now:

```elm
            NotReady time ->
                let
                    initTaco =
                        { currentTime = time
                        , translate = I18n.get translations
                        }

                    ( initRouterModel, routerCmd ) =
                        Router.init model.location
                in
                    ( { model | appState = Ready initTaco initRouterModel }
                    , Cmd.map RouterMsg routerCmd
                    )
```
Note that we use the `time` in the model to set the `initTaco`'s value, and we set the `translate` function based on the translations we just received. This taco is then set as a part of our `AppState`.

If we do have an app ready, let's update the taco while keeping the `routerModel` unchanged.

```elm
            Ready taco routerModel ->
                ( { model | appState = Ready (updateTaco taco (UpdateTranslations translations)) routerModel }
                , Cmd.none
                )
```



Just to make it clear, here's the whole function:

```elm
updateTranslations : Model -> WebData Translations -> ( Model, Cmd Msg )
updateTranslations model webData =
    case webData of
        Failure _ ->
            Debug.crash "OMG CANT EVEN DOWNLOAD."

        Success translations ->
            case model.appState of
                NotReady time ->
                    let
                        initTaco =
                            { currentTime = time
                            , translate = I18n.get translations
                            }

                        ( initRouterModel, routerCmd ) =
                            Router.init model.location
                    in
                        ( { model | appState = Ready initTaco initRouterModel }
                        , Cmd.map RouterMsg routerCmd
                        )

                Ready taco routerModel ->
                    ( { model | appState = Ready (updateTaco taco (UpdateTranslations translations)) routerModel }
                    , Cmd.none
                    )

        _ ->
            ( model, Cmd.none )
```

### Updating the Taco

We now know that the Taco is one half of what makes our application `Ready`, but how can we update the taco from some other place than the Main module? In [`Types.elm`](https://github.com/ohanhi/elm-taco/blob/master/src/Types.elm) we have the definition for `TacoUpdate`:

```elm
type TacoUpdate
    = NoUpdate
    | UpdateTime Time
    | UpdateTranslations Translations
```

And in [`Pages/Settings.elm`](https://github.com/ohanhi/elm-taco/blob/master/src/Pages/Settings.elm) we have the `update` function return one of them along with the typical `Model` and `Cmd Msg`:

```elm
update : Msg -> Model -> ( Model, Cmd Msg, TacoUpdate )
```

This obviously needs to be passed on also in the parent (`Router.elm`), which has the same signature for the update function. Then finally, back at the top level of our hierarchy, in the Main module we handle these requests to change the Taco for all modules.

```elm
updateRouter : Model -> Router.Msg -> ( Model, Cmd Msg )
updateRouter model routerMsg =
    case model.appState of
        Ready taco routerModel ->
            let
                ( nextRouterModel, routerCmd, tacoUpdate ) =
                    Router.update routerMsg routerModel

                nextTaco =
                    updateTaco taco tacoUpdate
            in
                ( { model | appState = Ready nextTaco nextRouterModel }
                , Cmd.map RouterMsg routerCmd
                )

-- ...

updateTaco : Taco -> TacoUpdate -> Taco
updateTaco taco tacoUpdate =
    case tacoUpdate of
        UpdateTime time ->
            { taco | currentTime = time }

        UpdateTranslations translations ->
            { taco | translate = I18n.get translations }

        NoUpdate ->
            taco
```

And that's it! I know it may be a little overwhelming, but take your time reading through the code and it will make sense. I promise. And if it doesn't, please put up an Issue so we can fix it!



## Credits and license

&copy; 2017 Ossi Hanhinen and Matias Klemola

Licensed under [BSD (3-clause)](LICENSE)
