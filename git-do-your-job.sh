#!/bin/bash

# Nome do script: git-do-your-job.sh
# Função: Inicializa repo, adiciona tudo (inclusive pastas vazias), comita e envia pro GitHub

echo "🚀 Iniciando o push automatizado..."

# Adiciona .gitkeep em pastas vazias
echo "🔍 Adicionando .gitkeep em pastas vazias..."
find . -type d -empty -not -path "./.git/*" -exec touch {}/.gitkeep \;

# Inicializa o repositório se ainda não existir
if [ ! -d .git ]; then
    echo "📁 Inicializando repositório Git..."
    git init
    git branch -M main
fi

# Adiciona todos os arquivos
git add .

# Commita
echo "📝 Commitando alterações..."
git commit -m "Push automatizado: inclui arquivos e pastas vazias com .gitkeep"

# Solicita a URL do repositório remoto se ainda não existir
if ! git remote | grep -q origin; then
    read -p "🔗 Cole aqui a URL do seu repositório GitHub: " repo_url
    git remote add origin "$repo_url"
fi

# Faz o push com force opcional se necessário
echo "🚚 Enviando para o GitHub (main)..."
git push -u origin main 2>&1 | tee push_output.log

if grep -q "fetch first" push_output.log; then
    echo "⚠️ Conflito detectado! Forçando push..."
    git push -f origin main
fi

# Limpeza
rm -f push_output.log

echo "✅ Push finalizado com sucesso!"

