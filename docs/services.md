# Описание сервисов, бизнес событий и связей

##Auth
* Producing:
  * Асинхронные:
    * CUD-события:
      * регистрация юзера _(public_id, email, name, role)_
      * редактирование юзера _(public_id, email, name, role)_
      * удаление юзера _(public_id)_
    * BE-события:
      * смена роли юзера _(public_id, role)_
* Consuming:
  * Синхронные:
    * BE-события:
      * Запрос аутентификации
        * из **Tracker service**
        * из **Accounting service**
        * из **Analytics service**

  
## Tracker
* Producing:
  * Асинхронные:
    * CUD-события:
        * добавление задачи _(public_id, name, description, status)_
    * BE-события:
        * назначение задачи _(public_id, account_public_id)_
        * закрытие задачи _(public_id)_
  * Синхронные:
    * BE-события:
      * Запрос аутентификации в **Auth service** _(account.email, account.password)_
* Consuming:
  * Асинхронные:
    * из **Auth service:**
      * CUD-события:
        * регистрация юзера
        * редактирование юзера
        * удаление юзера
      * BE-события:
        * смена роли юзера

## Accounting
* Producing:
  * Асинхронные:
    * BE-события:
      * Снижение баланса при назначении задачи юзеру _(account_public_id, task.fee)_
      * Повышение баланса при закрытии задачи юзером _(account_public_id, task.amount)_
      * Перенос отрицательного баланса на след день _(account_public_id, account.balance)_
      * Обнуление положительного баланса в конце дня _(account_public_id, account.balance)_
      * Генерация таксы и оплаты за таску при создании задачи _(task_public_id, task.fee, task.amount)_
  * Синхронные:
    * BE-события:
      * Запрос аутентификации в **Auth service** _(account.email, account.password)_
      * отправка писем юзерам (в бэкграунде)
* Consuming:
  * Асинхронные:
    * из **Auth service:**
      * CUD-события:
        * регистрация юзера
        * редактирование юзера
        * удаление юзера
      * BE-события:
        * смена роли юзера
    * из **Tracker service:**
      * CUD-события:
        * добавление задачи
      * BE-события:
        * назначение задачи
        * закрытие задачи

## Analytics
* Producing:
  * Синхронные:
    * Запрос аутентификации в **Auth service** _(account.email, account.password)_
* Consuming:
  * Асинхронные:
    * из **Auth service:**
      * CUD-события:
        * создание юзера
        * редактирование юзера
        * удаление юзера
      * BE-события:
        * смена роли юзера
    * из **Tracker service:**
      * CUD-события:
        * добавление задачи
      * BE-события:
        * назначение задачи
        * закрытие задачи
    * из **Accounting service:**
      * BE-события:
        * Снижение баланса при назначении задачи юзеру
        * Повышение баланса при закрытии задачи юзером
        * Перенос отрицательного баланса на след день
        * Обнуление положительного баланса в конце дня
