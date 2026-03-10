## Каталог доменных событий

В таблице ниже представлены все ключевые события, которые публикуются доменами. Для каждого события указаны:

- Событие – название события.
- Домен-источник – bounded context, в котором возникает событие.
- Семантика – бизнес-смысл события.
- Минимальный контракт – ключевые поля, которые обязательно присутствуют в событии.

| Событие              | Домен-источник | Семантика (бизнес-смысл)                         | Минимальный контракт (ключевые поля)                                                                                                                   |
|----------------------|----------------|--------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| PatientRegistered    | Patient        | Пациент зарегистрирован в системе                | `patientId` (UUID), `firstName` (string), `lastName` (string), `dateOfBirth` (date), `registrationDate` (datetime), `email` (string), `phone` (string) |
| MedicalRecordCreated | Patient        | Создана новая медицинская карта                  | `recordId` (UUID), `patientId` (UUID), `createdAt` (datetime), `description` (string, опционально)                                                     |
| DiagnosisAdded       | Patient        | Добавлен диагноз в медицинскую карту             | `diagnosisId` (UUID), `recordId` (UUID), `icdCode` (string), `diagnosisDate` (date), `notes` (string, опционально)                                     |
| AttachmentUploaded   | Patient        | Загружен файл исследования (снимок, PDF)         | `attachmentId` (UUID), `recordId` (UUID), `fileUrl` (string), `uploadedAt` (datetime), `type` (string: DICOM, PDF, и т.п.)                             |
| AppointmentScheduled | Appointment    | Запись на приём создана                          | `appointmentId` (UUID), `patientId` (UUID), `doctorId` (UUID), `timeSlot` (datetime), `status` (string: scheduled)                                     |
| AppointmentCancelled | Appointment    | Запись на приём отменена                         | `appointmentId` (UUID), `reason` (string, опционально), `cancelledAt` (datetime)                                                                       |
| AppointmentCompleted | Appointment    | Приём успешно завершён                           | `appointmentId` (UUID), `completedAt` (datetime), `summary` (string, опционально)                                                                      |
| InvoiceIssued        | Billing        | Выставлен счёт на оплату                         | `invoiceId` (UUID), `patientId` (UUID), `appointmentId` (UUID, опционально), `amount` (decimal), `dueDate` (date), `status` (string: issued)           |
| PaymentReceived      | Billing        | Получена оплата по счёту                         | `paymentId` (UUID), `invoiceId` (UUID), `amount` (decimal), `paymentDate` (datetime), `method` (string: cash, card, online)                            |
| LoanCreated          | Billing        | Оформлен кредитный договор                       | `loanId` (UUID), `patientId` (UUID), `principal` (decimal), `interestRate` (decimal), `startDate` (date)                                               |
| LoanStatusChanged    | Billing        | Изменён статус кредита                           | `loanId` (UUID), `newStatus` (string: active, closed, overdue), `changedAt` (datetime)                                                                 |
| StockLevelChanged    | Inventory      | Изменился остаток товара на складе               | `itemId` (UUID), `newQuantity` (integer), `changeReason` (string: shipment, sale, write-off), `changedAt` (datetime)                                   |
| ShipmentArrived      | Inventory      | Поставка от поставщика прибыла                   | `shipmentId` (UUID), `supplierId` (UUID), `items` (array of {itemId, quantity}), `arrivalDate` (date)                                                  |
| ReorderSuggested     | Inventory      | Предложение дозаказа (ниже минимального остатка) | `itemId` (UUID), `suggestedQuantity` (integer), `reason` (string: min_stock_reached)                                                                   |
| EmployeeHired        | HR             | Принят новый сотрудник                           | `employeeId` (UUID), `name` (string), `position` (string), `hireDate` (date)                                                                           |
| ScheduleAssigned     | HR             | Назначен график работы сотрудника                | `employeeId` (UUID), `scheduleId` (UUID), `shiftStart` (datetime), `shiftEnd` (datetime)                                                               |
| PayrollProcessed     | HR             | Произведён расчёт зарплаты                       | `payrollId` (UUID), `employeeId` (UUID), `period` (string: YYYY-MM), `amount` (decimal)                                                                |
| AnalysisRequested    | AI             | Запрошен анализ медицинских данных (ИИ)          | `requestId` (UUID), `patientId` (UUID), `medicalRecordId` (UUID), `analysisType` (string), `requestedAt` (datetime)                                    |
| AnalysisCompleted    | AI             | Анализ завершён, результат готов                 | `resultId` (UUID), `requestId` (UUID), `resultData` (json/string), `completedAt` (datetime)                                                            |
| NotificationSent     | Notification   | Уведомление отправлено получателю                | `notificationId` (UUID), `recipient` (string), `type` (string: email, push, sms), `sentAt` (datetime), `status` (string: sent, failed)                 |

## События, используемые в интеграционном мосту

Для взаимодействия с легаси-системами определены дополнительные технические события, которые не являются доменными, но
используются в интеграционном слое:

| Событие               | Источник           | Семантика                                                                  | Контракт                                              |
|-----------------------|--------------------|----------------------------------------------------------------------------|-------------------------------------------------------|
| LegacyRequestReceived | Camel              | Запрос от легаси-системы (PowerBuilder, старые API) преобразован в событие | `requestId`, `system`, `payload`, `timestamp`         |
| LegacyResponseSent    | Camel              | Ответ направлен в легаси-систему                                           | `requestId`, `system`, `responsePayload`, `timestamp` |
| DWHDataExtracted      | Kafka Connect JDBC | Порция данных выгружена из DWH для миграции                                | `table`, `rows`, `extractedAt`                        |
