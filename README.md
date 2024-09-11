Чтобы русифицировать консоль в Ubuntu, нужно настроить локаль и шрифты консоли, чтобы они поддерживали русский язык. Выполните следующие шаги:

### Шаг 1: Установка русской локали

1. Откройте терминал и выполните следующую команду для установки и генерации русской локали:

   ```bash
   sudo locale-gen ru_RU.UTF-8
   ```

2. После этого установите системную локаль по умолчанию на русский:

   ```bash
   sudo update-locale LANG=ru_RU.UTF-8
   ```

### Шаг 2: Изменение конфигурации консоли

1. Откройте файл `/etc/default/console-setup` с помощью текстового редактора:

   ```bash
   sudo nano /etc/default/console-setup
   ```

2. Найдите и измените следующие строки, если они не настроены:

   ```bash
   CHARMAP="UTF-8"
   CODESET="CyrSlav"
   FONTFACE="Terminus"
   FONTSIZE="16x32"
   ```

   Эти параметры позволяют консоли поддерживать русские символы.

3. Сохраните изменения и закройте файл (в редакторе Nano нажмите `Ctrl + X`, затем `Y` для подтверждения и `Enter`).

### Шаг 3: Настройка клавиатуры в консоли

1. Откройте файл `/etc/default/keyboard` для редактирования:

   ```bash
   sudo nano /etc/default/keyboard
   ```

2. Измените параметры на следующие:

   ```bash
   XKBLAYOUT="us,ru"
   XKBVARIANT=""
   XKBOPTIONS="grp:alt_shift_toggle"
   ```

   Это установит переключение раскладки клавиатуры по сочетанию `Alt + Shift` между английской и русской раскладкой.

3. Сохраните изменения и закройте файл.

### Шаг 4: Применение изменений

1. Примените настройки клавиатуры с помощью команды:

   ```bash
   sudo dpkg-reconfigure console-setup
   ```

2. Перезагрузите систему или переключитесь на консоль (Ctrl + Alt + F3) и проверьте, отображаются ли русские символы корректно.

Теперь консоль Ubuntu должна поддерживать русский язык и переключение раскладки клавиатуры.



------ git
установка прав после checkout
mcedit .git/hooks/post-checkout #>>>
```bash
#!/bin/bash
find . -type f -exec chmod 664 {} \;
find . -type d -exec chmod 2775 {} \;
```
```bash
chmod +x .git/hooks/post-checkout
```



Автоматическое добавление название ветки в начало сообщения коммита:
mcedit  .git/hooks/prepare-commit-msg #>>>
```bash
#!/bin/bash
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
COMMIT_MSG_FILE=$1
if ! grep -q "\[$BRANCH_NAME\]" "$COMMIT_MSG_FILE"; then
  sed -i.bak -e "1s|^|[$BRANCH_NAME] |" "$COMMIT_MSG_FILE"
fi
```
```bash
chmod +x .git/hooks/prepare-commit-msg
```




