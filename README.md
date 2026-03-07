# Сдача проектной работы 11 спринта

## Задание 1. Модульная инфраструктура для нескольких сред

### Файлы в модуле [modules/vm/](Task1Advanced/modules/vm/)

- variables.tf — определяет входные параметры модуля. Это «интерфейс» модуля: какие данные он ожидает получить.
- outputs.tf — определяет выходные данные модуля, которые модуль возвращает после создания ресурсов
- main.tf — содержит ресурсы, которые создаёт модуль (диск, ВМ).

### Файлы в окружении [envs/](Task1Advanced/modules/envs/)

Каждое окружение — это корневая конфигурация Terraform, которая использует модуль. У неё своя цель:

variables.tf (окружения) — определяет переменные, которые нужны конкретно этому окружению для работы. Сюда входят:

- учётные данные для провайдера Yandex Cloud (token, cloud_id, folder_id);
- параметры, которые будут переданы в модуль, чтобы их можно было задать через terraform.tfvars;

terraform.tfvars — файл со значениями переменных, определённых в variables.tf окружения. 
Здесь задаются конкретные цифры и строки для dev-среды, для stage, для prod.

main.tf (окружения) — содержит:

- Настройку провайдера (Yandex Cloud).
- Вызов модуля vm с передачей ему нужных параметров.

outputs.tf (окружения) — необязательный файл. Если он есть, то определяет, какие значения нужно вывести пользователю 
после применения конфигурации. Например, можно вывести IP-адрес созданной ВМ, обратившись к выходным данным модуля.

### Для запуска

- Установленный Terraform.
- Аккаунт в Yandex Cloud с созданным облаком и каталогом.
- OAuth-токен для доступа к API Yandex Cloud.
- SSH-ключ для доступа к виртуальной машине. Если ключа нет, создайте:

```bash
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
```
- Идентификаторы подсетей в каждой зоне для окружений. Их можно получить из консоли Yandex Cloud или через CLI.
- Для каждого окружения (dev, stage, prod) необходимо заполнить файл terraform.tfvars в соответствующем каталоге.
Определить параметр для подключения yandex_token - OAuth-токен

### Развёртывание инфраструктуры:
1. Перейдите в каталог нужного окружения

```bash
cd envs/dev          # или stage, prod
```
2. Инициализируйте Terraform (загрузит провайдер и модуль)

```bash
terraform init
```

3. Просмотрите план изменений

```bash
terraform plan
```

4. Примените конфигурацию для создания ресурсов

```bash
terraform apply
```

Полноценно протестировать не удалось. Не доступно зеркало для скачивания образов:

```
│ Error: Failed to query available provider packages
│
│ Could not retrieve the list of available versions for provider yandex-cloud/yandex: failed to query provider mirror https://terraform-provider.yandexcloud.net/ for
│ registry.terraform.io/yandex-cloud/yandex: response has invalid Content-Type: must be application/json
```

## Задание 2. Интеграция с CI/CD и удалённым хранением состояния

### Предварительные требования

1. Аккаунт в Yandex Cloud, созданное облако и каталог.
2. Сервисный аккаунт с ролью `editor` в каталоге.
3. Статический ключ доступа для сервисного аккаунта (получить через `yc iam access-key create`).
4. Бакет в Yandex Object Storage (например, `tfstate-bucket-dev`) с включённым версионированием.
5. Установленный Terraform.

### Настройка бэкенда

1. Перейдите в папку `envs/dev`.
2. Скопируйте `backend-dev.conf.example` в `backend-dev.conf` и укажите реальные данные бакета и ключей.
3. Инициализируйте Terraform:
   ```bash
   terraform init -reconfigure -backend-config=backend-dev.conf
   ```
4. В terraform.tfvars и отредактируйте, подставив свои cloud_id, folder_id, subnet_id и путь к SSH-ключу

CI/CD с GitHub Actions

### Необходимые секреты в репозитории

YC_STATIC_ACCESS_KEY - Идентификатор статического ключа
YC_STATIC_SECRET_KEY - Секретный ключ
YC_CLOUD_ID	ID - вашего облака
YC_FOLDER_ID - ID каталога
TF_STATE_BUCKET - Имя бакета для state-файлов 

### Безопасность

- Все секреты передаются через переменные окружения и секреты GitHub.
- Статические ключи используются как для бэкенда, так и для провайдера Yandex.
- Файлы с чувствительными данными (*.tfvars, backend-*.conf, *.json) добавлены в .gitignore.
- В CI/CD конфигурация бэкенда создаётся динамически и не сохраняется в репозитории.

### Описание файлов CI/CD: plan.yml и apply.yml

В проекте используются два основных workflow GitHub Actions для автоматизации Terraform в окружении dev:

- plan.yml – запускается при создании или обновлении Pull Request (PR) и выполняет terraform plan, публикуя результат в комментариях к PR.
- apply.yml – запускается после мержа PR (push в целевую ветку) и выполняет terraform apply для применения изменений.

#### plan.yml Шаги

- checkout – клонирует репозиторий.
- setup-terraform – устанавливает Terraform нужной версии.
- Configure backend – создаёт временный конфигурационный файл для бэкенда, подставляя значения из секретов.
- Terraform Init – инициализирует рабочую директорию с этим бэкендом.
- Terraform Plan – выполняет terraform plan и выводит результат в лог (всё видно в интерфейсе Actions).

#### apply.yml Отличия от plan.yml

- Триггер – push в ветку develop (т.е. после мержа PR).
- Шаг Terraform Apply – использует флаг -auto-approve, что соответствует требованию «apply по кнопке или с флагом approval».
- Все остальные шаги идентичны, что гарантирует одинаковое окружение для plan и apply.


Полноценно протестировать не удалось. Не доступно зеркало для скачивания образов:

```
│ Error: Failed to query available provider packages
│
│ Could not retrieve the list of available versions for provider yandex-cloud/yandex: failed to query provider mirror https://terraform-provider.yandexcloud.net/ for
│ registry.terraform.io/yandex-cloud/yandex: response has invalid Content-Type: must be application/json
```