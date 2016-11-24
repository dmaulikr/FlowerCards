//
//  ru.swift
//  Flowers
//
//  Created by Jozsef Romhanyi on 20.09.15.
//  Copyright © 2015 Jozsef Romhanyi. All rights reserved.
//


let ruDictionary: [TextConstants: String] = [
    .tcAktLanguage:      "ru",
    .tcLevel:            "Уровень%",
    .tcLevelScore:       "Очки%",
    .tcCardHead:         "Карты",
    .tcScoreHead:        "Очки",
    .tcScore:            "Очки",
    .tcTime:             "Время",
    .tcActScore:         "Очки последней игры: ",
    .tcBestScore:        "Лучшие очки",
    .tcTargetScore:      "Получить очки: ",
    .tcGameLost:         "Ты проиграл!",
    .tcGameLost3:        "Ты проиграл в 3 раза! Назад к предыдущему уровню!",
    .tcTargetNotReached: "Цель не достигнутa",
    .tcSpriteCount:      "количество цветов:",
    .tcCardCount:        "количество карт:",
    .tcReturn:           "Назад",
    .tcok:               "OK",
    .tcGameComplete:     "Игра % завершена!",
    .tcNoMessage:        "Сообщение не найдёно",
    .tcTimeout:          "Время закончилось",
    .tcGameOver:         "Игра проиграна",
    .tcCongratulations:  "Поздравляю ",
    .tcChooseName:       "Список игроков",
    .tcVolume:           "Громкость",
    .tcCountHelpLines:   "кол. вспомогательных линий",
    .tcLanguage:         "Язык",
    .tcEnglish:          "English (Английский)",
    .tcGerman:           "Deutsch (Немецкий)",
    .tcHungarian:        "Magyar (Венгерский)",
    .tcRussian:          "Русский (Русский)",
    .tcCancel:           "Отменить",
    .tcDone:             "Готово",
    .tcModify:           "Изменить",
    .tcDelete:           "Удалить",
    .tcNewName:          "Новый игрок",
    .tcChooseLanguage:   "Выбoр языка",
    .tcPlayer:           "Игрок: %",
    .tcGameModus:        "Тип игры",
    .tcSoundVolume:      "Громкость звука",
    .tcMusicVolume:      "Громкость музыки",
    .tcStandardGame:     "Игра с цветами",
    .tcCardGame:         "Игра с картами",
    .tcPreviousLevel:    "Предыдущий уровень",
    .tcNextLevel:        "Следующий уровень",
    .tcNewGame:          "Новая игра",
    .tcGameAgain:        "Повторить игру",
    .tcChooseGame:       "Выберите пожалуйста:",
    .tcTippCount:        "Kоличество возможных ходов: ",
    .tcStatistics:       "Игра % на уровне %",
    .tcActTime:          "Продолжительность игры: ",
    .tcBestTimeForLevel: "Лучшее время уровня: ",
    .tcBestTime:         "Лучшее время",
    .tcAllTimeForLevel:  "Полное время уровня: ",
    .tcAllTime:          "Bремя",
    .tcCountPlaysForLevel: "До сих пор % игр",
    .tcCountPlays:        "Игры",
    .tcCountCompetitions: "Соревн.",
    .tcCountVictorys:     "Побед / Поражений",
    .tcGameCompleteWithBestScore: "Новый рекорд очков на уровне %!",
    .tcGameCompleteWithBestTime:  "Новый рекорд времени на уровне % ",
    .tcGuest:            "Гость",
    .tcAnonym:           "Anonymus",
    .tcStatistic:        "Статистика",
    .tcPlayerStatisticHeader: "Статистика игрока %",
    .tcPlayerStatisticLevel: "Статистика игрока %, уровень: %",
    .tcStatisticOfGame:  "Статистика %-й игры",
    .tcBestScoreOfGame:   "Лучший результат % %",
    .tcYourScore:         "Твой результат %",
    .tcYouAreTheBest:    "Вы самый лучший со счетом %",
    .tcGameNumber:       "Игра: #%",
//    .tcChooseGameNumber: "Выбери игру",
//    .TCPlayerStatistic:  "Статистика игроков",
//    .TCGameStatistic:    "Статистика игр",
    .tcCompetition:      "Соревнование",
    .tcCompetitionShort: "Соревн.",
    .tcGame:             "Игра",
    .tcChoosePartner:    "Выбери противника:",
    .tcWantToPlayWithYou:"% хочет с тобой поиграть!",
    .tcOpponent:         "Противник:%",
    .tcOpponentHasFinished: "% закончил игру #%!\r\n" +
                        "его/ee бонус: %\r\n" +
                        "его/ee очки: %\r\n" +
                        "твои очки: %\r\n ",
    .tcYouHaveFinished: "ты закончил игру #%!\r\n" +
                        "твой бонус: %\r\n" +
                        "твои очки: %\r\n" +
                        "% очки: %\r\n ",
    .tcHeWon:           "% победил нa % - %!\r\n" +
                        "K сожалению :-(",
    .tcYouWon:          "ты победил нa % - %! \r\n" +
                        "Поздравляю!!!",
    .tcOpponentNotPlay: "% не хочет с тобой играть!",
    .tcOpponentLevelIsLower: "% ещё не достиг твой уровень",
    .tcGameArt:         "Tип",
    .tcVictory:         "Победa",
    .tcStart:           "Старт",
    .tcStopCompetition: "Стоп cоревнование",
    .tcOpponentStoppedTheGame: "% остановил игру",
    .tcAreYouSureToDelete: "Действитель удалить игрока %?\r\n" +
                           "Все его данные будут удалены!",
    .tcHelpURL:         "http://jogaxplay.hu/portl/ru",
    .tcj:               "В",
    .tcd:               "Д",
    .tck:               "К",
    .tcWhoIs:           "Кто",
    .tcName:            "Имя",
    .tcPlayerType:      "Игрок",
    .tcOpponentType:    "Противник",
    .tcBestPlayerType:  "Лучший игрок",
    .tcChooseLevel:     "Выберите уровень и параметры",
    .tcLevelAndGames:   "Уровень (сыграно)",
    .tcSize:            "Формат:",
    .tcPackages:        "Пакете:",
    .tcHelpLines:       "Тип помощи:",

]
