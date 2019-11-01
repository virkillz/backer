module Backerzone exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, a, button, div, form, h1, i, img, input, li, nav, span, text, ul, select, option, textarea)
import Html.Attributes exposing (action, value, alt, class, href, id, method, name, src, type_, target, attribute, placeholder)
import Html.Events exposing (onClick)
import Html.Parser
import Html.Parser.Util
import Http
import Json.Decode exposing (Decoder, bool, decodeString, field, list, string)



---- MODEL ----

type ZoneType
    = Donee
    | Backer

type DoneezoneActivePage 
        = DoneezoneTimeline
        | DoneezoneMyBacker
        | DoneezoneStatistic
        | DoneezoneFinance
        | DoneezoneSetting

type alias Model =
    { listNotif : List Notification
    , avatar : String
    , isDonee : Bool
    , notifCount : String
    , toggleSearch : Bool
    , toggleMenu : Bool
    , currentZone : ZoneType
    , toggleNotification : Bool }


type alias Notification =
    { ago : String
    , content : String
    , icon : String
    , id : String
    , thumbnail : String
    , isRead : Bool
    }


init : ( String, Bool, String ) -> ( Model, Cmd Msg )
init ( avatar, isDonee, notifCount ) =
    ( { listNotif = []
    , avatar = avatar
    , notifCount = notifCount
    , isDonee = isDonee
    , toggleSearch = False
    , toggleNotification = False
    , currentZone = Backer
    , toggleMenu = False }
    , initNotification )



viewHelperZoneSwitch: ZoneType -> ZoneType -> String
viewHelperZoneSwitch currentZone correctZone =
    case currentZone of 
        Backer -> 
            if currentZone == correctZone then 
                 " border-indigo-500 "
            else
                " border-transparent " 
        Donee ->
            if currentZone == correctZone then
                " border-orange-500 "
                else
                " border-transparent "

---- UPDATE ----


type Msg
    = NoOp
    | ToggleSearch
    | ToggleNotification
    | ToggleMenu
    | SwitchOffAll
    | SwitchZone
    | Whatever (Result Http.Error ())
    | GotNotif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSearch ->
            ( { model | toggleSearch = not model.toggleSearch, toggleMenu = False, toggleNotification = False }, Cmd.none )

        ToggleMenu ->
            ( { model | toggleMenu = not model.toggleMenu, toggleSearch = False, toggleNotification = False }, Cmd.none )

        ToggleNotification ->
            ( { model | toggleNotification = not model.toggleNotification, notifCount = "0", toggleMenu = False, toggleSearch = False }, resetNotif )

        SwitchOffAll ->
            ( { model | toggleNotification = False, toggleMenu = False, toggleSearch = False }, Cmd.none )

        SwitchZone ->
            ( switchZone model, Cmd.none )

        GotNotif result ->
            case result of
                Ok rawString ->
                    ( { model | listNotif = extractListNotification rawString }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        Whatever result ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- HELPER ----


textHtml : String -> List (Html.Html msg)
textHtml t =
    case Html.Parser.run t of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []


initNotification : Cmd Msg
initNotification =
    Http.get
        { url = "http://localhost:4000/private/notification"
        , expect = Http.expectString GotNotif
        }


resetNotif : Cmd Msg
resetNotif =
    Http.get
        { url = "http://localhost:4000/private/notification/reset-counter"
        , expect = Http.expectWhatever Whatever
        }

switchZone : Model -> Model 
switchZone model =
    if model.currentZone == Backer then
        {model | currentZone = Donee}
    else
         {model | currentZone = Backer}


-- extractListNotification :


extractListNotification : String -> List Notification
extractListNotification string =
    let
        debug =
            Debug.log "raw string"
                string
    in
    case decodeString decodeListNotification string of
        Ok resource ->
            resource

        Err err ->
            []


decodeListNotification : Decoder (List Notification)
decodeListNotification =
    list decodeNotification


decodeNotification : Decoder Notification
decodeNotification =
    Json.Decode.map6 Notification
        (field "ago" string)
        (field "content" string)
        (field "icon" string)
        (field "id" string)
        (field "thumbnail" string)
        (field "is_read" bool)


toggleDropdown : Bool -> String
toggleDropdown isVisible =
    if isVisible then
        "mt-20 z-50 "

    else
        "hidden mt-0 z-0 "


ifDonee : Bool -> List (Html Msg)
ifDonee isDonee =
    if isDonee then
        [ li [ class "" ]
            [ a [ class "hover:text-orange-500 transition transition-all", href "/doneezone" ]
                [ div [ class "hover:bg-orange-100 px-6 py-1" ]
                    [ text "Donee Area" ]
                ]
            ]
        ]

    else
        []


viewHelperNotifCount : String -> Html Msg
viewHelperNotifCount string =
    if string == "0" then
        span [] []

    else
        span [ class "text-xs bg-red-500 text-white p-1 -ml-3 rounded-lg" ]
            [ text string ]


notificationPrinter : Notification -> Html Msg
notificationPrinter notif =
    li [ class "py-1" ]
        [ a [ class "bg-white transition transition-all text-xs", href <| "/backerzone/notifications/" ++ notif.id ]
            [ div [ class "flex px-4 py-1 border-t bg-white hover:bg-purple-100" ]
                [ img [ alt "", class "rounded-lg w-12 h-12 mr-4", src notif.thumbnail ]
                    []
                , div [ class "" ]
                    [ div [ class "" ] <|
                        textHtml
                            notif.content
                    , div [ class "" ]
                        [ span [ class "mr-2" ] <| textHtml notif.icon
                        , text notif.ago
                        , viewNotificationIsRead notif
                        ]
                    ]
                ]
            ]
        ]


viewNotificationIsRead : Notification -> Html Msg
viewNotificationIsRead notif =
    if notif.isRead then
        span [] []

    else
        span [ class "py-px px-2 rounded bg-orange-500 text-white ml-2" ]
            [ text "new" ]


toggleOrangeColor : Bool -> String
toggleOrangeColor isVisible =
    if isVisible then
        "text-orange-500 "

    else
        "text-gray-700 "



---- VIEW ----


view : Model -> Html Msg 
view model = 
    div [] [viewNav model, viewBackerzoneTimeline model]


viewNav : Model -> Html Msg
viewNav model =
    nav [ class "h-18 fixed bg-white shadow transition-all transition-ease w-full z-30 top-0 text-white", id "headerx" ]
        [ div [ class "w-full relative container mx-auto flex flex-wrap items-center justify-between mt-0 py-2" ]
            [ div [ class "pl-4 flex items-center" ]
                [ a [ class "toggleColour text-white no-underline hover:no-underline font-bold text-2xl lg:text-4xl", href "/" ]
                    [ img [ alt "", class "h-8 ", src "http://alpha.backer.id/assets/images/logo/backer-bg-white.png" ]
                        []
                    ]
                ]
            , div [ class "pr-4 flex items-center" ]
                [ ul [ class "hidden lg:flex text-white lg:text-gray-700 flex-1 items-center" ]
                    [ li [ class "mr-3" ]
                        [ a [ class " py-2 px-4 font-semibold", href "/explore" ]
                            [ text "Explore Community" ]
                        ]
                    , li [ class "mr-3" ]
                        [ a [ class " font-semibold py-2 px-4", href "/blog" ]
                            [ text "Blog" ]
                        ]
                    ]
                , div [ class " rounded-lg py-1 px-4 bg-gray-200 mx-2" ]
                    [ div [ class " rounded-lg py-1 lg:px-4 bg-gray-200 mx-2" ]
                        [ a [ class "inline-block text-3xl text-gray-700 hover:text-orange-500 no-underline px-2 transition-all", href "/home" ]
                            [ i [ class "la la-home" ]
                                []
                            ]
                        , a [ onClick ToggleSearch, class <| toggleOrangeColor model.toggleSearch ++ " inline-block text-3xl hover:text-orange-500 no-underline px-2 transition-all", href "#" ]
                            [ i [ class "la la-search" ]
                                []
                            ]
                        , div [ onClick ToggleNotification, class <| toggleOrangeColor model.toggleNotification ++ " inline-block text-3xl cursor-pointer hover:text-orange-500 no-underline px-2 transition-all" ]
                            [ i [ class "la la-bell" ]
                                []
                            , viewHelperNotifCount model.notifCount
                            ]
                        ]
                    ]
                , div [ onClick ToggleMenu, class "flex items-center cursor-pointer overflow-hidden" ]
                    [ img [ alt "", class "rounded-lg w-12 object-cover h-12", src model.avatar ]
                        []
                    , i [ class "fa fa-caret-down text-black ml-1" ]
                        []
                    ]
                ]
            , div [ class <| toggleDropdown model.toggleSearch ++ " absolute right-0 top-0 rounded-lg mr-10 bg-white shadow-lg py-4 px-6 transition transition-all" ]
                [ form [ action "/search", class "rounded-lg border", method "get" ]
                    [ i [ class "fa fa-search text-black font-bold px-2" ]
                        []
                    , input [ class "border-l py-1 px-3 text-gray-600 focus:outline-none", type_ "search", name "q" ]
                        []
                    , button [ class "px-3 border-l text-orange-500 text-xs" ]
                        [ text "Search" ]
                    ]
                ]
            , div [ class <| toggleDropdown model.toggleMenu ++ " right-0 top-0 rounded-lg absolute bg-white shadow-lg text-black py-4 float-left transition transition-all" ]
                [ ul [] <|
                    ifDonee model.isDonee
                        ++ [ li [ class "" ]
                                [ a [ class "hover:text-orange-500 transition transition-all", href "/backerzone" ]
                                    [ div [ class "hover:bg-orange-100 px-6 py-1" ]
                                        [ text "Backer Area" ]
                                    ]
                                ]
                           , li [ class "" ]
                                [ a [ class "block lg:hidden hover:text-orange-500 transition transition-all", href "/explore" ]
                                    [ div [ class "hover:bg-orange-100 px-6 py-1" ]
                                        [ text "Explore Donee" ]
                                    ]
                                ]
                           , li [ class "" ]
                                [ a [ class "block lg:hidden hover:text-orange-500 transition transition-all", href "/blog" ]
                                    [ div [ class "hover:bg-orange-100 px-6 py-1" ]
                                        [ text "Blog" ]
                                    ]
                                ]
                           , li [ class "border-b py-1" ]
                                []
                           , li [ class "" ]
                                [ a [ class "hover:text-orange-500 transition transition-all", href "/signout" ]
                                    [ div [ class "hover:bg-orange-100 px-6 py-1" ]
                                        [ text "Log Out" ]
                                    ]
                                ]
                           ]
                ]
            , div [ class <| toggleDropdown model.toggleNotification ++ " right-0 top-0 mr-24 rounded-lg absolute bg-white shadow-lg py-4 transition transition-all" ]
                [ ul [ class "bg-white text-black" ] <|
                    List.map
                        notificationPrinter
                        model.listNotif
                , div [ class "pt-2 px-2 border-t text-center text-blue-500 underline" ]
                    [ a [ href "/notifications" ]
                        [ text "See all notification" ]
                    ]
                ]
            ]
        ]

viewBackerzoneTimeline : Model -> Html Msg
viewBackerzoneTimeline model =
    div [ class "bg-gray-200 lg:mt-16" ]
    [ div [ class "pt-10 container mx-auto lg:flex" ]
        [ div [ class "lg:w-1/4 px-4 lg:pb-10" ]
            [ div [ class "transition-all", attribute "style" "top: 96px; position: sticky;" ]
                [ div [ class "pt-16 lg:hidden" ]
                    []
                , div [ class "lg:hidden" ]
                    [ div [ class "text-xl font-title" ]
                        [ span [ class "font-bold" ]
                            [ text "Hello, " ]
                        , span [ class "" ]
                            [ text "LBH Jakarta" ]
                        , text "!"
                        ]
                    ]
                , div [ class "wow fadeIn hidden lg:block animated", attribute "style" "visibility: visible;" ]
                    [ div [ class "flex items-center" ]
                        [ div [ class "mr-2 z-20" ]
                            [ img [ class "w-16 h-16 shadow object-center object-cover rounded-full", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                                []
                            ]
                        , div [ class "z-10 py-2 pl-16 -ml-16 pr-4 shadow rounded-full bg-white" ]
                            [ div [ class "text-gray-700 font-title font-semibold" ]
                                [ text "LBH Jakarta" ]
                            , div [ class " text-xs" ]
                                [ text "@donee-1 "
                                , a [ href "/donee/donee-1", target "_blank" ]
                                    [ span [ class "ml-4 font-semibold text-xs uppercase text-indigo-400" ]
                                        [ text "profil donee "
                                        , i [ class "la la-external-link" ]
                                            []
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "flex justify-between mt-6" ]
                    [ div [ onClick SwitchZone ]
                        [ div [ class <| viewHelperZoneSwitch model.currentZone Backer ++ " px-2 py-4 lg:mb-0 text-center tracking-wide cursor-pointer font-title font-semibold  uppercase text-sm border-b-8 border-transparent hover:border-indigo-500" ]
                            [ text "backer menu" ]
                        ]
                    , div [ onClick SwitchZone ]
                        [ div [ class <| viewHelperZoneSwitch model.currentZone Donee ++ " px-2 py-4 lg:mb-0 text-center tracking-wide cursor-pointer font-title font-semibold uppercase text-sm border-b-8 border-transparent hover:border-orange-500" ]
                            [ text "donee menu" ]
                        ]
                    ]
                , div [ class "border-b-2 mb-6 -mt-px" ]
                    []
                , div [ class "flex lg:block justify-center items-start my-6" ]
                    [ a [ href "/doneezone/timeline-live" ]
                        [ div [ class " font-semibold text-orange-500  mb-2 lg:flex text-center cursor-pointer py-2 px-4 mx-px lg:px-6 lg:border-b-0 hover:text-orange-500 transition-all transition-ease transition-500" ]
                            [ i [ class "la la-newspaper-o text-xl lg:mr-4" ]
                                []
                            , div [ class "font-title" ]
                                [ text "My Posts" ]
                            ]
                        ]
                    , a [ href "/doneezone/backers" ]
                        [ div [ class "  mb-2 lg:flex text-center cursor-pointer py-2 px-4 mx-px lg:px-6 hover:text-orange-500 transition-all transition-ease transition-500" ]
                            [ i [ class "la la-users text-xl lg:mr-4" ]
                                []
                            , div [ class "font-title" ]
                                [ text "My Backers" ]
                            ]
                        ]
                    , a [ href "/doneezone/statistic" ]
                        [ div [ class "  mb-2 lg:flex text-center cursor-pointer py-2 px-4 mx-px lg:px-6 hover:text-orange-500 transition-all transition-ease transition-500" ]
                            [ i [ class "la la-bar-chart-o text-xl lg:mr-4" ]
                                []
                            , div [ class " font-title" ]
                                [ text "Statistic " ]
                            ]
                        ]
                    , a [ href "/doneezone/finance" ]
                        [ div [ class "  mb-2 lg:flex text-center cursor-pointer py-2 px-4 mx-px lg:px-6 hover:text-orange-500 transition-all transition-ease transition-500" ]
                            [ i [ class "la la-credit-card text-xl lg:mr-4" ]
                                []
                            , div [ class "font-title" ]
                                [ text "Keuangan" ]
                            ]
                        ]
                    , a [ href "/doneezone/setting" ]
                        [ div [ class "  mb-2 lg:flex text-center cursor-pointer py-2 px-2 mx-px lg:px-6 hover:text-orange-500 transition-all transition-ease transition-500" ]
                            [ i [ class "la la-cog text-xl lg:mr-4" ]
                                []
                            , div [ class " font-title" ]
                                [ text "Pengaturan" ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "lg:w-2/4 px-4 pb-20" ]
            [ div [ class "phx-connected", attribute "data-phx-session" "SFMyNTY.g3QAAAACZAAEZGF0YWgCYQF0AAAABmQAAmlkbQAAAAxwaHgtd1lqMDYwRmFkAApwYXJlbnRfcGlkZAADbmlsZAAIcm9vdF9waWRkAANuaWxkAAZyb3V0ZXJkAANuaWxkAAdzZXNzaW9udAAAAAJkAAtiYWNrZXJfaW5mb3QAAAAjZAAFcGhvbmVkAANuaWxkAAh1c2VybmFtZW0AAAAHZG9uZWUtMWQACl9fc3RydWN0X19kABxFbGl4aXIuQmFja2VyLkFjY291bnQuQmFja2VyZAAOcGFzc3dvcmRyZXBlYXRkAANuaWxkAAtpZF9waG90b2t5Y2QAA25pbGQADWlzX3NlYXJjaGFibGVkAAR0cnVlZAANaXNfYWdyZWVfdGVybWQAA25pbGQADHBhc3N3b3JkaGFzaG0AAAA8JDJiJDEyJGZVcDBSc29vMjlnR3EyMzFnU3ZSWmVrSDZ2UDRWUmZHVTB3aGJsdHlCNDhQU3hhTjZJOE1XZAAKYmlydGhfZGF0ZWQAA25pbGQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEIZAAEaG91cmEWZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhCWQABW1vbnRoYQpkAAZzZWNvbmRhOWQABHllYXJiAAAH42QACGludm9pY2VzdAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAARtYW55ZAAJX19maWVsZF9fZAAIaW52b2ljZXNkAAlfX293bmVyX19kABxFbGl4aXIuQmFja2VyLkFjY291bnQuQmFja2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQACGlkX3Bob3RvZAADbmlsZAAJaWRfbnVtYmVyZAADbmlsZAAWcGFzc3dvcmRfcmVjb3ZlcnlfY29kZWQAA25pbGQABmJhZGdlc3QAAAAEZAAPX19jYXJkaW5hbGl0eV9fZAAEbWFueWQACV9fZmllbGRfX2QABmJhZGdlc2QACV9fb3duZXJfX2QAHEVsaXhpci5CYWNrZXIuQWNjb3VudC5CYWNrZXJkAApfX3N0cnVjdF9fZAAhRWxpeGlyLkVjdG8uQXNzb2NpYXRpb24uTm90TG9hZGVkZAAXcGhvbmVfdmVyaWZpY2F0aW9uX2NvZGVkAANuaWxkAAdpZF90eXBlbQAAAANrdHBkAAhwYXNzd29yZGQAA25pbGQABmF2YXRhcm0AAABiaHR0cHM6Ly92a2JhY2tlci5zMy5hbWF6b25hd3MuY29tL3ZrYmFja2VyL2VkNjdkNTk1LWZlMGYtNDdjZi1hZmE5LTlhYTdkMjM5MDU3OS1sYmhqYWthcnRhbG9nby5wbmdkABFpc19lbWFpbF92ZXJpZmllZGQABHRydWVkAApiYWNrZXJfYmlvbQAAAB1MZW1iYWdhIEJhbnR1YW4gSHVrdW0gSmFrYXJ0YWQAEWlzX3Bob25lX3ZlcmlmaWVkZAAFZmFsc2VkAAlpc19saXN0ZWRkAAR0cnVlZAANcmVjb3Zlcl9waG9uZWQAA25pbGQABGNvZGVkAANuaWxkAAZnZW5kZXJkAANuaWxkAAxkaXNwbGF5X25hbWVtAAAAC0xCSCBKYWthcnRhZAAXZW1haWxfdmVyaWZpY2F0aW9uX2NvZGVtAAAAJDg0ODAyYzg4LTVhNDEtNGE4Ni04OWY5LWE3MzgyMDM2YTYzZWQACF9fbWV0YV9fdAAAAAZkAApfX3N0cnVjdF9fZAAbRWxpeGlyLkVjdG8uU2NoZW1hLk1ldGFkYXRhZAAHY29udGV4dGQAA25pbGQABnByZWZpeGQAA25pbGQABnNjaGVtYWQAHEVsaXhpci5CYWNrZXIuQWNjb3VudC5CYWNrZXJkAAZzb3VyY2VtAAAAB2JhY2tlcnNkAAVzdGF0ZWQABmxvYWRlZGQACWZ1bGxfbmFtZWQAA25pbGQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhBWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQZkAAVtb250aGEJZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-NkAAVkb25lZXQAAAAEZAAPX19jYXJkaW5hbGl0eV9fZAADb25lZAAJX19maWVsZF9fZAAFZG9uZWVkAAlfX293bmVyX19kABxFbGl4aXIuQmFja2VyLkFjY291bnQuQmFja2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQABWVtYWlsbQAAABFkb25lZTFAdGVzdGVyLmNvbWQAAmlkYQtkAAhpc19kb25lZWQABHRydWVkAApkb25lZV9pbmZvdAAAABtkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkABtFbGl4aXIuQmFja2VyLkFjY291bnQuRG9uZWVkAAZzb3VyY2VtAAAABmRvbmVlc2QABXN0YXRlZAAGbG9hZGVkZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5CYWNrZXIuQWNjb3VudC5Eb25lZWQACmFjY291bnRfaWRkAANuaWxkAAxhY2NvdW50X25hbWVkAANuaWxkAA5hZGRyZXNzX3B1YmxpY2QAA25pbGQABmJhY2tlcnQAAAAjZAAFcGhvbmVkAANuaWxkAAh1c2VybmFtZW0AAAAHZG9uZWUtMWQACl9fc3RydWN0X19kABxFbGl4aXIuQmFja2VyLkFjY291bnQuQmFja2VyZAAOcGFzc3dvcmRyZXBlYXRkAANuaWxkAAtpZF9waG90b2t5Y2QAA25pbGQADWlzX3NlYXJjaGFibGVkAAR0cnVlZAANaXNfYWdyZWVfdGVybWQAA25pbGQADHBhc3N3b3JkaGFzaG0AAAA8JDJiJDEyJGZVcDBSc29vMjlnR3EyMzFnU3ZSWmVrSDZ2UDRWUmZHVTB3aGJsdHlCNDhQU3hhTjZJOE1XZAAKYmlydGhfZGF0ZWQAA25pbGQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEIZAAEaG91cmEWZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhCWQABW1vbnRoYQpkAAZzZWNvbmRhOWQABHllYXJiAAAH42QACGludm9pY2VzdAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAARtYW55ZAAJX19maWVsZF9fZAAIaW52b2ljZXNkAAlfX293bmVyX19kABxFbGl4aXIuQmFja2VyLkFjY291bnQuQmFja2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQACGlkX3Bob3RvZAADbmlsZAAJaWRfbnVtYmVyZAADbmlsZAAWcGFzc3dvcmRfcmVjb3ZlcnlfY29kZWQAA25pbGQABmJhZGdlc3QAAAAEZAAPX19jYXJkaW5hbGl0eV9fZAAEbWFueWQACV9fZmllbGRfX2QABmJhZGdlc2QACV9fb3duZXJfX2QAHEVsaXhpci5CYWNrZXIuQWNjb3VudC5CYWNrZXJkAApfX3N0cnVjdF9fZAAhRWxpeGlyLkVjdG8uQXNzb2NpYXRpb24uTm90TG9hZGVkZAAXcGhvbmVfdmVyaWZpY2F0aW9uX2NvZGVkAANuaWxkAAdpZF90eXBlbQAAAANrdHBkAAhwYXNzd29yZGQAA25pbGQABmF2YXRhcm0AAABiaHR0cHM6Ly92a2JhY2tlci5zMy5hbWF6b25hd3MuY29tL3ZrYmFja2VyL2VkNjdkNTk1LWZlMGYtNDdjZi1hZmE5LTlhYTdkMjM5MDU3OS1sYmhqYWthcnRhbG9nby5wbmdkABFpc19lbWFpbF92ZXJpZmllZGQABHRydWVkAApiYWNrZXJfYmlvbQAAAB1MZW1iYWdhIEJhbnR1YW4gSHVrdW0gSmFrYXJ0YWQAEWlzX3Bob25lX3ZlcmlmaWVkZAAFZmFsc2VkAAlpc19saXN0ZWRkAAR0cnVlZAANcmVjb3Zlcl9waG9uZWQAA25pbGQABGNvZGVkAANuaWxkAAZnZW5kZXJkAANuaWxkAAxkaXNwbGF5X25hbWVtAAAAC0xCSCBKYWthcnRhZAAXZW1haWxfdmVyaWZpY2F0aW9uX2NvZGVtAAAAJDg0ODAyYzg4LTVhNDEtNGE4Ni04OWY5LWE3MzgyMDM2YTYzZWQACF9fbWV0YV9fdAAAAAZkAApfX3N0cnVjdF9fZAAbRWxpeGlyLkVjdG8uU2NoZW1hLk1ldGFkYXRhZAAHY29udGV4dGQAA25pbGQABnByZWZpeGQAA25pbGQABnNjaGVtYWQAHEVsaXhpci5CYWNrZXIuQWNjb3VudC5CYWNrZXJkAAZzb3VyY2VtAAAAB2JhY2tlcnNkAAVzdGF0ZWQABmxvYWRlZGQACWZ1bGxfbmFtZWQAA25pbGQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhBWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQZkAAVtb250aGEJZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-NkAAVkb25lZXQAAAAEZAAPX19jYXJkaW5hbGl0eV9fZAADb25lZAAJX19maWVsZF9fZAAFZG9uZWVkAAlfX293bmVyX19kABxFbGl4aXIuQmFja2VyLkFjY291bnQuQmFja2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQABWVtYWlsbQAAABFkb25lZTFAdGVzdGVyLmNvbWQAAmlkYQtkAAhpc19kb25lZWQABHRydWVkAAxiYWNrZXJfY291bnRhA2QACWJhY2tlcl9pZGELZAAKYmFja2dyb3VuZG0AAAB2aHR0cHM6Ly92a2JhY2tlci5zMy5hbWF6b25hd3MuY29tL3ZrYmFja2VyLzhkOGVlZWU3LTY0MDAtNDcyNi1hOGQ4LTQ1ZmNiMWVmMDA5My1TY3JlZW5fU2hvdF8yMDE5LTEwLTA5X2F0XzA0LjU1LjE5LnBuZ2QAEWJhbmtfYm9va19waWN0dXJlZAADbmlsZAAJYmFua19uYW1lZAADbmlsZAAIY2F0ZWdvcnl0AAAABGQAD19fY2FyZGluYWxpdHlfX2QAA29uZWQACV9fZmllbGRfX2QACGNhdGVnb3J5ZAAJX19vd25lcl9fZAAbRWxpeGlyLkJhY2tlci5BY2NvdW50LkRvbmVlZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQAC2NhdGVnb3J5X2lkYQFkAA5kb25lZV9vdmVydmlld20AAAXnPHA-PHN0cm9uZz5MZW1iYWdhIEJhbnR1YW4gSHVrdW0gKExCSCkgSmFrYXJ0YTwvc3Ryb25nPjwvcD48YnIgLz48cD5MZW1iYWdhIEJhbnR1YW4gSHVrdW0gKExCSCkgSmFrYXJ0YSBkaWRpcmlrYW4gYXRhcyBnYWdhc2FuIHlhbmcgZGlzYW1wYWlrYW4gcGFkYSBLb25ncmVzIFBlcnNhdHVhbiBBZHZva2F0IEluZG9uZXNpYSAoUGVyYWRpbikga2UgSUlJIHRhaHVuIDE5NjkuIEdhZ2FzYW4gdGVyc2VidXQgbWVuZGFwYXQgcGVyc2V0dWp1YW4gZGFyaSBEZXdhbiBQaW1waW5hbiBQdXNhdCBQZXJhZGluIG1lbGFsdWkgU3VyYXQgS2VwdXR1c2FuIE5vbW9yIDAwMS9LZXAvMTAvMTk3MCB0YW5nZ2FsIDI2IE9rdG9iZXIgMTk3MCB5YW5nIGlzaSBwZW5ldGFwYW4gcGVuZGlyaWFuIExlbWJhZ2EgQmFudHVhbiBIdWt1bSBKYWthcnRhIGRhbiBMZW1iYWdhIFBlbWJlbGEgVW11bSB5YW5nIG11bGFpIGJlcmxha3UgdGFuZ2dhbCAyOCBPa3RvYmVyIDE5NzAuPC9wPjxwPjxiciAvPjwvcD48cD5QZW5kaXJpYW4gTEJIIEpha2FydGEgeWFuZyBkaWR1a3VuZyBwdWxhIG9sZWggUGVtZXJpbnRhaCBEYWVyYWggKFBlbWRhKSBES0kgSmFrYXJ0YSBpbmksIHBhZGEgYXdhbG55YSBkaW1ha3N1ZGthbiB1bnR1ayBtZW1iZXJpa2FuIGJhbnR1YW4gaHVrdW0gYmFnaSBvcmFuZy1vcmFuZyB5YW5nIHRpZGFrIG1hbXB1IGRhbGFtIG1lbXBlcmp1YW5na2FuIGhhay1oYWtueWEsIHRlcnV0YW1hIHJha3lhdCBtaXNraW4geWFuZyBkaWd1c3VyLCBkaXBpbmdnaXJrYW4sIGRpIFBISywgZGFuIHBlbGFuZ2dhcmFuIGF0YXMgaGFrLWhhayBhc2FzaSBtYW51c2lhIHBhZGEgdW11bW55YS48L3A-PHA-PGJyIC8-PC9wPjxwPkxhbWJhdCBsYXVuIExCSCBKYWthcnRhwqAgbWVuamFkaSBvcmdhbmlzYXNpIHBlbnRpbmcgYmFnaSBnZXJha2FuIHByby1kZW1va3Jhc2kuIEhhbCBpbmkgZGlzZWJhYmthbiB1cGF5YSBMQkggSmFrYXJ0YSBtZW1iYW5ndW4gZGFuIG1lbmphZGlrYW4gbmlsYWktbmlsYWkgaGFrIGFzYXNpIG1hbnVzaWEgZGFuIGRlbW9rcmFzaSBzZWJhZ2FpIHBpbGFyIGdlcmFrYW4gYmFudHVhbiBodWt1bSBkaSBJbmRvbmVzaWEuIENpdGEtY2l0YSBpbmkgZGl0YW5kYWkgZGVuZ2FuIHNlbWFuZ2F0IHBlcmxhd2FuYW4gdGVyaGFkYXAgcmV6aW0gb3JkZSBiYXJ1IHlhbmcgZGlwaW1waW4gb2xlaCBTb2VoYXJ0byB5YW5nIGJlcmFraGlyIGRlbmdhbiBhZGFueWEgcGVyZ2VzZXJhbiBrZXBlbWltcGluYW4gcGFkYSB0YWh1biAxOTk4LiBCdWthbiBoYW55YSBpdHUsIHNlbWFuZ2F0IG1lbGF3YW4ga2V0aWRha2FkaWxhbiB0ZXJoYWRhcCBzZWx1cnVoIHBlbmd1YXNhIG1lbmphZGkgYmVudHVrIGFkdm9rYXNpIHlhbmcgZGlsYWt1a2FuIHNla2FyYW5nLiBTZW1hbmdhdCBpbmkgbWVydXBha2FuIGJlbnR1ayBwZW5nLWtyaXRpc2FuIHRlcmhhZGFwIHBlcmxpbmR1bmdhbiwgcGVtZW51aGFuIGRhbiBwZW5naG9ybWF0YW4gSGFrIEFzYXNpIE1hbnVzaWEgZGkgSW5kb25lc2lhLjwvcD5kAA1mZWF0dXJlZF9wb3N0ZAADbmlsZAACaWRhAWQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhBWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQZkAAVtb250aGEJZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-NkAAlpc19saXN0ZWRkAAR0cnVlZAANaXNfc2VhcmNoYWJsZWQABHRydWVkAApwb3N0X2NvdW50YS5kAAZzdGF0dXNtAAAACXB1Ymxpc2hlZGQAB3RhZ2xpbmVtAAAAHUxlbWJhZ2EgQmFudHVhbiBIdWt1bSBKYWthcnRhZAAEdGllcmwAAAADdAAAAAlkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkAB1FbGl4aXIuQmFja2VyLk1hc3RlcmRhdGEuVGllcmQABnNvdXJjZW0AAAAFdGllcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kAB1FbGl4aXIuQmFja2VyLk1hc3RlcmRhdGEuVGllcmQABmFtb3VudGIAAMNQZAALZGVzY3JpcHRpb25tAAAAPVlvdSB0cmVhdCB1cyBkZWNlbnQgbWVhbCwgb25jZSBhIG1vbnRoLiBSZWFsbHkgYXBwcmVjaWF0ZSBpdC5kAAhkb25lZV9pZGEBZAACaWRhAmQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhBWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQZkAAVtb250aGEJZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-NkAAV0aXRsZW0AAAAMSGVhdnkgQmFja2VyZAAKdXBkYXRlZF9hdHQAAAAJZAAKX19zdHJ1Y3RfX2QAFEVsaXhpci5OYWl2ZURhdGVUaW1lZAAIY2FsZW5kYXJkABNFbGl4aXIuQ2FsZW5kYXIuSVNPZAADZGF5YRxkAARob3VyYQtkAAttaWNyb3NlY29uZGgCYQBhAGQABm1pbnV0ZWEFZAAFbW9udGhhCWQABnNlY29uZGEeZAAEeWVhcmIAAAfjdAAAAAlkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkAB1FbGl4aXIuQmFja2VyLk1hc3RlcmRhdGEuVGllcmQABnNvdXJjZW0AAAAFdGllcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kAB1FbGl4aXIuQmFja2VyLk1hc3RlcmRhdGEuVGllcmQABmFtb3VudGIAAYagZAALZGVzY3JpcHRpb25tAAAAMldlIGNhbiBkbyBzb21lIHN0dWZmIHdpdGggdGhpcyBkZWZpbml0ZWx5LiBUaGFua3MhZAAIZG9uZWVfaWRhAWQAAmlkYQNkAAtpbnNlcnRlZF9hdHQAAAAJZAAKX19zdHJ1Y3RfX2QAFEVsaXhpci5OYWl2ZURhdGVUaW1lZAAIY2FsZW5kYXJkABNFbGl4aXIuQ2FsZW5kYXIuSVNPZAADZGF5YRZkAARob3VyYQVkAAttaWNyb3NlY29uZGgCYQBhAGQABm1pbnV0ZWEGZAAFbW9udGhhCWQABnNlY29uZGERZAAEeWVhcmIAAAfjZAAFdGl0bGVtAAAADFVsdHJhIEJhY2tlcmQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEcZAAEaG91cmELZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhBGQABW1vbnRoYQlkAAZzZWNvbmRhNGQABHllYXJiAAAH43QAAAAJZAAIX19tZXRhX190AAAABmQACl9fc3RydWN0X19kABtFbGl4aXIuRWN0by5TY2hlbWEuTWV0YWRhdGFkAAdjb250ZXh0ZAADbmlsZAAGcHJlZml4ZAADbmlsZAAGc2NoZW1hZAAdRWxpeGlyLkJhY2tlci5NYXN0ZXJkYXRhLlRpZXJkAAZzb3VyY2VtAAAABXRpZXJzZAAFc3RhdGVkAAZsb2FkZWRkAApfX3N0cnVjdF9fZAAdRWxpeGlyLkJhY2tlci5NYXN0ZXJkYXRhLlRpZXJkAAZhbW91bnRiAAAnEGQAC2Rlc2NyaXB0aW9ubQAAADlFcXVhbCB0byBhIGN1cCBvZiBjb2ZmZWUuIFRyZWF0IHVzIG9uY2UgaW4gYSBtb250aCBtYXliZT9kAAhkb25lZV9pZGEBZAACaWRhAWQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhBWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQZkAAVtb250aGEJZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-NkAAV0aXRsZW0AAAAMTGlnaHQgQmFja2VyZAAKdXBkYXRlZF9hdHQAAAAJZAAKX19zdHJ1Y3RfX2QAFEVsaXhpci5OYWl2ZURhdGVUaW1lZAAIY2FsZW5kYXJkABNFbGl4aXIuQ2FsZW5kYXIuSVNPZAADZGF5YRxkAARob3VyYQtkAAttaWNyb3NlY29uZGgCYQBhAGQABm1pbnV0ZWEEZAAFbW9udGhhCWQABnNlY29uZGEVZAAEeWVhcmIAAAfjamQABXRpdGxldAAAAAlkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkAB5FbGl4aXIuQmFja2VyLk1hc3RlcmRhdGEuVGl0bGVkAAZzb3VyY2VtAAAABnRpdGxlc2QABXN0YXRlZAAGbG9hZGVkZAAKX19zdHJ1Y3RfX2QAHkVsaXhpci5CYWNrZXIuTWFzdGVyZGF0YS5UaXRsZWQAEmRlZmF1bHRfYmFja2dyb3VuZGQAA25pbGQAC2Rlc2NyaXB0aW9uZAADbmlsZAACaWRhAWQAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhBWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQZkAAVtb250aGEJZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-NkAAlpc19hY3RpdmVkAAR0cnVlZAAEbmFtZW0AAAAXTm9uIFByb2ZpdCBPcmdhbml6YXRpb25kAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhFmQABGhvdXJhBWQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYQZkAAVtb250aGEJZAAGc2Vjb25kYRFkAAR5ZWFyYgAAB-NkAAh0aXRsZV9pZGEBZAAKdXBkYXRlZF9hdHQAAAAJZAAKX19zdHJ1Y3RfX2QAFEVsaXhpci5OYWl2ZURhdGVUaW1lZAAIY2FsZW5kYXJkABNFbGl4aXIuQ2FsZW5kYXIuSVNPZAADZGF5YR1kAARob3VyYQxkAAttaWNyb3NlY29uZGgCYQBhAGQABm1pbnV0ZWEVZAAFbW9udGhhCmQABnNlY29uZGEwZAAEeWVhcmIAAAfjZAANdmlkZW9fcHJvZmlsZW0AAAALUkFRNjRLMHQ1b1FkAAR2aWV3ZAAmRWxpeGlyLkJhY2tlcldlYi5Eb25lZXpvbmVUaW1lbGluZUxpdmVkAAZzaWduZWRuBgAfSZsbbgE.9BwOT-dM0LKjLCZoOeK8tP2KHdKkm4bbkRtq4OLLASE", attribute "data-phx-view" "DoneezoneTimelineLive", id "phx-wYj060Fa" ]
                [ div [ class "bg-white px-4 text-gray-600 py-4 mb-4 border rounded-lg shadow" ]
                    [ div [ class "flex justify-end" ]
                        [ div [ class " shadow-inner bg-gray-100  hover:shadow-inner hover:bg-gray-100  cursor-pointer px-6 py-1 rounded-l-full transition-all border flex items-center", attribute "phx-click" "switch-mode", attribute "phx-value-mode" "text" ]
                            [ i [ class "la la-edit text-xl mr-2" ]
                                []
                            , div [ class "text-xs" ]
                                [ text "Text" ]
                            ]
                        , div [ class " hover:shadow-inner hover:bg-gray-100  cursor-pointer px-6 py-1 transition-all flex border-t border-b items-center", attribute "phx-click" "switch-mode", attribute "phx-value-mode" "image" ]
                            [ i [ class "la la-photo text-xl mr-2" ]
                                []
                            , div [ class "text-xs" ]
                                [ text "Image" ]
                            ]
                        , div [ class " hover:shadow-inner hover:bg-gray-100  cursor-pointer px-6 py-1 rounded-r-full transition-all border flex items-center", attribute "phx-click" "switch-mode", attribute "phx-value-mode" "video" ]
                            [ i [ class "la la-youtube text-xl mr-2" ]
                                []
                            , div [ class "text-xs " ]
                                [ text "Video" ]
                            ]
                        ]
                    , div [ class "flex pt-4" ]
                        [ img [ alt "", class "object-center object-cover w-12 h-12 rounded-full", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                            []
                        , div [ class "w-full ml-4" ]
                            [ form [ action "#", attribute "phx-submit" "post" ]
                                [ input [ class "focus:outline-none border-b text-sm rounded-fullx bg-gray-100x w-full  mb-2 px-4 py-2", attribute "maxlength" "160", name "title", placeholder "Judul", type_ "text", value "" ]
                                    []
                                , div [ class " hidden  flex items-center px-4 rounded-lg bg-gray-100 mb-2", attribute "maxlength" "160" ]
                                    [ i [ class "la la-photo text-xl mr-2" ]
                                        []
                                    , input [ class "focus:outline-none text-sm bg-gray-100 w-full py-2", name "image-link", placeholder "http://link-to-image", type_ "text" ]
                                        []
                                    ]
                                , div [ class " hidden  flex items-center px-4 rounded-lg bg-gray-100 mb-4", attribute "maxlength" "16" ]
                                    [ i [ class "la la-youtube text-xl mr-2" ]
                                        []
                                    , div [ class "flex py-1" ]
                                        [ span [ class "z-10 text-gray-500" ]
                                            [ text "https://youtube.com/watch?v=" ]
                                        , input [ class "inline border-b-2 text-sm focus:border-green-500 bg-gray-100 border-gray-500 block pr-2 pb-1 focus:outline-none", name "video", type_ "text" ]
                                            []
                                        ]
                                    ]
                                , textarea [ class "focus:outline-none text-sm rounded-lg bg-gray-100 w-full  p-4", attribute "cols" "30", id "", attribute "maxlength" "2000", name "content", placeholder "Konten...", attribute "rows" "5" ]
                                    []
                                , div [ class "flex pt-1 justify-between items-center flex-wrap" ]
                                    [ div [ class "py-2 flex items-center" ]
                                        [ div [ class "mr-2 text-xs px-2 pb-px" ]
                                            [ text "Dapat dilihat oleh" ]
                                        , select [ class " h-8 w-40 focus:outline-none bg-white", name "min-tier" ]
                                            [ option [ value "0" ]
                                                [ text "Semua orang" ]
                                            , option [ value "10000" ]
                                                [ text "Light Backer" ]
                                            , option [ value "100000" ]
                                                [ text "Ultra Backer" ]
                                            , option [ value "50000" ]
                                                [ text "Heavy Backer" ]
                                            ]
                                        ]
                                    , div [ class "" ]
                                        [ button [ class "hover:shadow-lg tracking-wide shadow focus:outline-none px-12 w-full py-2 outline-none transition-all transition-ease bg-orange-500 text-white rounded-full", attribute "phx-disable-with" "Submitting..", type_ "submit" ]
                                            [ text "Post" ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , div [ class " px-2 mb-2 tracking-wide font-semibold font-title text-gray-600 uppercase text-sm" ]
                    [ text "Postingan terbaru" ]
                , div [ class "rounded-lg bg-white shadow pt-4 px-4 pb-2 mb-4" ]
                    [ div [ class "flex justify-between items-center" ]
                        [ div [ class "flex items-center" ]
                            [ img [ class "w-12 h-12 object-center object-cover rounded-full border-4 border-white mr-2", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                                []
                            , div [ class "" ]
                                [ div [ class "text-gray-600 text-sm font-title font-semibold" ]
                                    [ text "LBH Jakarta" ]
                                , div [ class "text-gray-500 text-xs" ]
                                    [ text "19 hours ago" ]
                                ]
                            ]
                        , div [ class "" ]
                            [ div [ class "text-right bg-gray-400 text-white mt-px text-xs uppercase py-px px-4 rounded-full bg-gray-400 font-semibold" ]
                                [ text "public " ]
                            ]
                        ]
                    , div [ class "border-bx mt-4 mb-4" ]
                        []
                    , div [ class "text-gray-600 my-8 font-semibold font-title text-center text-xlx px-2" ]
                        [ text "jlhlkhjkljklj" ]
                    , div [ class "p-2 text-gray-600 text-justify leading-relaxed" ]
                        [ text "jkljkljkljljkljklj" ]
                    , div [ class "flex justify-between items-center mt-4" ]
                        [ div []
                            []
                        , div [ class "text-xs text-right mt-4 text-gray-600" ]
                            [ span []
                                []
                            , text "0 like • 0 comments"
                            ]
                        ]
                    , div [ class "border-bx mt-2" ]
                        []
                    , div [ class "flex text-gray-600" ]
                        [ div [ class "text-center  w-1/2 py-2 cursor-pointer hover:bg-gray-100 border-t", attribute "phx-click" "toggle_like", attribute "phx-value-post-id" "4" ]
                            [ i [ class "la la-thumbs-up mr-2" ]
                                []
                            , text "Like"
                            ]
                        , div [ class "w-1/2" ]
                            [ a [ href "/backerzone/timeline-live/4" ]
                                [ div [ class "text-center border-t py-2 cursor-pointer hover:bg-gray-100" ]
                                    [ i [ class "la la-comment mr-2" ]
                                        []
                                    , text "Comment"
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "border-b mb-2" ]
                        []
                    , div [ class "flex items-center" ]
                        [ img [ class "rounded-full border-4 border-white mr-2 h-12 w-12 object-cover object-center", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                            []
                        , input [ class "flex-grow py-2 border text-sm px-4 focus:outline-none bg-gray-100 rounded-full", placeholder "Tulis komentar kamu..." ]
                            []
                        , button [ class "px-4 text-xs focus:outline-none font-semibold font-title text-indigo-500 uppercase tracking-wide" ]
                            [ text "Kirim" ]
                        ]
                    ]
                , div [ class "rounded-lg bg-white shadow pt-4 px-4 pb-2 mb-4" ]
                    [ div [ class "flex justify-between items-center" ]
                        [ div [ class "flex items-center" ]
                            [ img [ class "w-12 h-12 object-center object-cover rounded-full border-4 border-white mr-2", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                                []
                            , div [ class "" ]
                                [ div [ class "text-gray-600 text-sm font-title font-semibold" ]
                                    [ text "LBH Jakarta" ]
                                , div [ class "text-gray-500 text-xs" ]
                                    [ text "19 hours ago" ]
                                ]
                            ]
                        , div [ class "" ]
                            [ div [ class "text-right bg-gray-400 text-white mt-px text-xs uppercase py-px px-4 rounded-full bg-gray-400 font-semibold" ]
                                [ text "public " ]
                            ]
                        ]
                    , div [ class "border-bx mt-4 mb-4" ]
                        []
                    , div [ class "text-gray-600 my-8 font-semibold font-title text-center text-xlx px-2" ]
                        [ text "Test" ]
                    , div [ class "p-2 text-gray-600 text-justify leading-relaxed" ]
                        [ text "adsad" ]
                    , div [ class "flex justify-between items-center mt-4" ]
                        [ div []
                            []
                        , div [ class "text-xs text-right mt-4 text-gray-600" ]
                            [ span []
                                []
                            , text "0 like • 0 comments"
                            ]
                        ]
                    , div [ class "border-bx mt-2" ]
                        []
                    , div [ class "flex text-gray-600" ]
                        [ div [ class "text-center  w-1/2 py-2 cursor-pointer hover:bg-gray-100 border-t", attribute "phx-click" "toggle_like", attribute "phx-value-post-id" "3" ]
                            [ i [ class "la la-thumbs-up mr-2" ]
                                []
                            , text "Like"
                            ]
                        , div [ class "w-1/2" ]
                            [ a [ href "/backerzone/timeline-live/3" ]
                                [ div [ class "text-center border-t py-2 cursor-pointer hover:bg-gray-100" ]
                                    [ i [ class "la la-comment mr-2" ]
                                        []
                                    , text "Comment"
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "border-b mb-2" ]
                        []
                    , div [ class "flex items-center" ]
                        [ img [ class "rounded-full border-4 border-white mr-2 h-12 w-12 object-cover object-center", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                            []
                        , input [ class "flex-grow py-2 border text-sm px-4 focus:outline-none bg-gray-100 rounded-full", placeholder "Tulis komentar kamu..." ]
                            []
                        , button [ class "px-4 text-xs focus:outline-none font-semibold font-title text-indigo-500 uppercase tracking-wide" ]
                            [ text "Kirim" ]
                        ]
                    ]
                , div [ class "rounded-lg bg-white shadow pt-4 px-4 pb-2 mb-4" ]
                    [ div [ class "flex justify-between items-center" ]
                        [ div [ class "flex items-center" ]
                            [ img [ class "w-12 h-12 object-center object-cover rounded-full border-4 border-white mr-2", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                                []
                            , div [ class "" ]
                                [ div [ class "text-gray-600 text-sm font-title font-semibold" ]
                                    [ text "LBH Jakarta" ]
                                , div [ class "text-gray-500 text-xs" ]
                                    [ text "1 day ago" ]
                                ]
                            ]
                        , div [ class "" ]
                            [ div [ class "text-right bg-indigo-500 text-white mt-px text-xs uppercase py-px px-4 rounded-full bg-gray-400 font-semibold" ]
                                [ text "Light Backer " ]
                            ]
                        ]
                    , div [ class "border-bx mt-4 mb-4" ]
                        []
                    , div [ class "text-gray-600 my-8 font-semibold font-title text-center text-xlx px-2" ]
                        [ text "Highcharts Demo" ]
                    , div [ class "p-2 text-gray-600 text-justify leading-relaxed" ]
                        [ text "sdfsdfdsf" ]
                    , div [ class "flex justify-between items-center mt-4" ]
                        [ div []
                            []
                        , div [ class "text-xs text-right mt-4 text-gray-600" ]
                            [ span []
                                []
                            , text "1 like • 6 comments"
                            ]
                        ]
                    , div [ class "border-bx mt-2" ]
                        []
                    , div [ class "flex text-gray-600" ]
                        [ div [ class "text-center  text-indigo-500  w-1/2 py-2 cursor-pointer hover:bg-gray-100 border-t", attribute "phx-click" "toggle_like", attribute "phx-value-post-id" "2" ]
                            [ i [ class "la la-thumbs-up mr-2" ]
                                []
                            , text "Like"
                            ]
                        , div [ class "w-1/2" ]
                            [ a [ href "/backerzone/timeline-live/2" ]
                                [ div [ class "text-center border-t py-2 cursor-pointer hover:bg-gray-100" ]
                                    [ i [ class "la la-comment mr-2" ]
                                        []
                                    , text "Comment"
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "border-b mb-2" ]
                        []
                    , div [ class "flex items-center" ]
                        [ img [ class "rounded-full border-4 border-white mr-2 h-12 w-12 object-cover object-center", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                            []
                        , input [ class "flex-grow py-2 border text-sm px-4 focus:outline-none bg-gray-100 rounded-full", placeholder "Tulis komentar kamu..." ]
                            []
                        , button [ class "px-4 text-xs focus:outline-none font-semibold font-title text-indigo-500 uppercase tracking-wide" ]
                            [ text "Kirim" ]
                        ]
                    ]
                , div [ class "rounded-lg bg-white shadow pt-4 px-4 pb-2 mb-4" ]
                    [ div [ class "flex justify-between items-center" ]
                        [ div [ class "flex items-center" ]
                            [ img [ class "w-12 h-12 object-center object-cover rounded-full border-4 border-white mr-2", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                                []
                            , div [ class "" ]
                                [ div [ class "text-gray-600 text-sm font-title font-semibold" ]
                                    [ text "LBH Jakarta" ]
                                , div [ class "text-gray-500 text-xs" ]
                                    [ text "1 day ago" ]
                                ]
                            ]
                        , div [ class "" ]
                            [ div [ class "text-right bg-gray-400 text-white mt-px text-xs uppercase py-px px-4 rounded-full bg-gray-400 font-semibold" ]
                                [ text "public " ]
                            ]
                        ]
                    , div [ class "border-bx mt-4 mb-4" ]
                        []
                    , div [ class "text-gray-600 my-8 font-semibold font-title text-center text-xlx px-2" ]
                        [ text "Highcharts Demo" ]
                    , div [ class "p-2 text-gray-600 text-justify leading-relaxed" ]
                        [ text "test satu dya . tiuga" ]
                    , div [ class "flex justify-between items-center mt-4" ]
                        [ div []
                            []
                        , div [ class "text-xs text-right mt-4 text-gray-600" ]
                            [ span []
                                []
                            , text "1 like • 0 comments"
                            ]
                        ]
                    , div [ class "border-bx mt-2" ]
                        []
                    , div [ class "flex text-gray-600" ]
                        [ div [ class "text-center  text-indigo-500  w-1/2 py-2 cursor-pointer hover:bg-gray-100 border-t", attribute "phx-click" "toggle_like", attribute "phx-value-post-id" "1" ]
                            [ i [ class "la la-thumbs-up mr-2" ]
                                []
                            , text "Like"
                            ]
                        , div [ class "w-1/2" ]
                            [ a [ href "/backerzone/timeline-live/1" ]
                                [ div [ class "text-center border-t py-2 cursor-pointer hover:bg-gray-100" ]
                                    [ i [ class "la la-comment mr-2" ]
                                        []
                                    , text "Comment"
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "border-b mb-2" ]
                        []
                    , div [ class "flex items-center" ]
                        [ img [ class "rounded-full border-4 border-white mr-2 h-12 w-12 object-cover object-center", src "https://vkbacker.s3.amazonaws.com/vkbacker/ed67d595-fe0f-47cf-afa9-9aa7d2390579-lbhjakartalogo.png" ]
                            []
                        , input [ class "flex-grow py-2 border text-sm px-4 focus:outline-none bg-gray-100 rounded-full", placeholder "Tulis komentar kamu..." ]
                            []
                        , button [ class "px-4 text-xs focus:outline-none font-semibold font-title text-indigo-500 uppercase tracking-wide" ]
                            [ text "Kirim" ]
                        ]
                    ]
                ]
            ]
        ]
    ]


---- PROGRAM ----
-- main : Program String Model Msg


main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
