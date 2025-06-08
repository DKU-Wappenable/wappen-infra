#!/bin/bash

# 개발 편의 스크립트

echo "🚀 Wappen Mall 개발 스크립트"
echo "=========================="
echo "1. 일반 시작 (데이터 보존)"
echo "2. 스키마 리셋 시작 (데이터 삭제)"
echo "3. 개발 모드 시작 (상세 로그)"
echo "4. 컨테이너 중지"
echo "5. 데이터베이스 볼륨 삭제"
echo "=========================="

read -p "선택하세요 (1-5): " choice

case $choice in
    1)
        echo "🔄 일반 모드로 시작 (데이터 보존)..."
        export DDL_AUTO=update
        docker compose up --build
        ;;
    2)
        echo "🔥 스키마 리셋 모드로 시작 (데이터 삭제)..."
        export DDL_AUTO=create-drop
        docker compose up --build
        ;;
    3)
        echo "🐛 개발 모드로 시작 (상세 로그)..."
        export DDL_AUTO=update
        export SPRING_PROFILES_ACTIVE=dev
        docker compose up --build
        ;;
    4)
        echo "⏹️ 컨테이너 중지..."
        docker compose down
        ;;
    5)
        echo "🗑️ 데이터베이스 볼륨 삭제..."
        docker compose down -v
        docker volume rm wappen-db-data-dev 2>/dev/null || true
        echo "볼륨이 삭제되었습니다."
        ;;
    *)
        echo "❌ 잘못된 선택입니다."
        ;;
esac 