# Базовый образ Node.js
FROM node:18-alpine

# Установка необходимых зависимостей для PostgreSQL client
RUN apk add --no-cache postgresql-client

# Рабочая директория
WORKDIR /app

# Копируем файлы управления зависимостями
COPY package*.json ./
COPY prisma ./prisma/

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы проекта
COPY . .

# Копируем .env.example в .env если .env не существует
#RUN cp -n .env.example .env || true

# Генерируем Prisma Client
RUN npx prisma generate

# Собираем приложение
RUN npm run build

# Открываем порт (согласно .env.example)
EXPOSE 4002

# Запускаем приложение
CMD npx prisma db push && npm run dev