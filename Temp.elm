module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing
    ( value
    , id
    )
import Html.Events exposing
    ( onClick
    , onInput
    )
import Html.App exposing (beginnerProgram)
import Html.Keyed as Keyed



-- MAIN

main : Program Never
main =
    beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }



-- MODEL

type alias Model =
    { tempBook : String
    , bookList : List Book
    , uid : Int
    , filter : Maybe BookStatus
    }

initialModel : Model
initialModel =
    { tempBook = ""
    , bookList = []
    , uid = 1
    , filter = Nothing
    }

type alias Book =
    { title : String
    , id : Int
    , status : BookStatus
    }

type BookStatus -- what's the difference between type and type alias
    = Unread
    | Started
    | Read

statusToString : BookStatus -> String
statusToString status =
    case status of
        Unread -> "unread"
        Started -> "started"
        Read -> "read"


-- UPDATE

type Msg
    = AddBook
    | TempBook String
    | ChangeStatus Int
    | ShowOnly BookStatus
    | ShowAll

update : Msg -> Model -> Model
update msg model =
    case msg of
        (TempBook bookTitle) ->
            { model | tempBook = bookTitle }

        AddBook ->
            { model
            | bookList = model.bookList ++
                [
                    { title = model.tempBook
                    , id = model.uid
                    , status = Unread
                    }
                ]
            , tempBook = ""
            , uid = model.uid + 1
            }
        
        (ChangeStatus id) ->
            { model | bookList = List.map (changeStatus id) model.bookList }

        (ShowOnly status) ->
            { model | filter = Just status }

        ShowAll ->
            { model | filter = Nothing }

changeStatus : Int -> Book -> Book
changeStatus id book =
    if id == book.id then
        case book.status of
            Unread ->
                { book | status = Started }
            Started ->
                { book | status = Read }
            Read ->
                { book | status = Unread }
    else
        book



-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "you're booked" ]
        , printBooks (Just Started) model.bookList
        , input [ onInput TempBook, value model.tempBook ] []
        , button [ onClick AddBook ] [ text "Add another" ]
        , div []
            [ button [ onClick ShowAll ] [ text "View All" ]
            , button [ onClick (ShowOnly Unread) ] [ text "Unread" ]
            , button [ onClick (ShowOnly Read) ] [ text "Read" ]
        ]
        , printBooks model.filter model.bookList
        ]

printBooks : Maybe BookStatus -> List Book -> Html Msg
printBooks status books =
    let
        filteredBooks = case status of
            Nothing ->
                books
            Just (s) ->
                List.filter (\b -> b.status == s) books

        keyTitles = \b -> (toString b.id, printTitle b)

    in
        Keyed.ul [] ( List.map keyTitles filteredBooks )

printTitle : Book -> Html Msg
printTitle book =
    li
        [ id (toString book.id)
        , onClick (ChangeStatus book.id)
        ]
        [ text (book.title ++ " " ++ (statusToString book.status)) ]