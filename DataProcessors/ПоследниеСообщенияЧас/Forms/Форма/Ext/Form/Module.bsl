﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

#КонецОбласти


///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьНаСервере()
	
	ПоследниеЧас.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Компоненты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Компоненты КАК Компоненты
		|ГДЕ
		|	Компоненты.Использование";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл			
			ТекстОшибки = Неопределено;
			Логи = Компоненты.ЛогиКомпоненты(Выборка.Ссылка);			
			Если ТекстОшибки = Неопределено Тогда				
				Для Каждого Лог Из Логи Цикл
					Попытка
						Сообщения = Компоненты.Сообщения(Выборка.Ссылка, Лог, ТекущаяДатаСеанса() - 3600, ТекущаяДатаСеанса());							
						Для Каждого Сообщение Из Сообщения Цикл
							НоваяСтрока = ПоследниеЧас.Добавить();
							НоваяСтрока.Компонента = Выборка.Ссылка;
							НоваяСтрока.Лог        = Лог;							
							ЗаполнитьЗначенияСвойств(НоваяСтрока, Сообщение);
						КонецЦикла;
					Исключение
						Сообщить(ОписаниеОшибки());
					КонецПопытки;
				КонецЦикла;				
			Иначе
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти