# 📊 Wappenable 시각화 – Epic / Story / Task / ERD

| 구분 | 다이어그램 | 설명 |
|------|-----------|------|
| **1** | Flowchart | Epic 모듈·데이터 흐름 |
| **2** | Sequence | Story 1.x (회원가입·로그인) 클/서 동선 |
| **3** | ERD | 인증 & 커머스 도메인 모델 |
| **4** | Gantt | Sprint 1·2 Task 일정 |

> **미리보기** VS Code(<em>Markdown Preview Mermaid Support</em>)·GitHub·Notion 등 Mermaid 지원 뷰어에서 확인하세요.

---

## Epic 레벨 Flowchart (모듈·데이터 흐름)

```mermaid
flowchart LR
  %% Frontend
  subgraph Frontend ["Frontend SPA"]
    FE_Auth["Auth Module\n(React / Axios)"]
    FE_Product["Product Module"]
    FE_Order["Order Module"]
  end

  %% Backend
  subgraph Backend ["Spring Boot API"]
    BE_Auth["Auth Service\n(JWT + OAuth2)"]
    BE_Product["Product Service"]
    BE_Order["Order Service"]
    BE_Admin["Role / Admin API"]
  end

  %% Storage
  subgraph Storage ["MySQL + S3"]
    DB[(MySQL)]
    S3[(S3 Bucket)]
  end

  %% Flows
  FE_Auth -- REST --> BE_Auth
  FE_Product -- REST --> BE_Product
  FE_Order -- REST --> BE_Order
  FE_Auth -- JWT --> FE_Product

  BE_Auth -- SQL --> DB
  BE_Product -- SQL --> DB
  BE_Order -- SQL --> DB
  BE_Product -- "img" --> S3
  BE_Admin -- SQL --> DB
```
---
## Epic 1 – Story 1.x Sequence Diagram
```mermaid
sequenceDiagram
  autonumber
  actor User
  participant FE as "Front-End"
  participant BE as "Back-End"
  participant DB as "MySQL DB"

  User->>FE: 회원가입 입력
  FE->>BE: POST /api/users/signup
  BE->>DB: INSERT User
  DB-->>BE: OK
  BE-->>FE: 201 Created
  FE-->>User: 환영 + /login

  User->>FE: 로그인 입력
  FE->>BE: POST /api/users/login
  BE->>DB: SELECT pwHash
  DB-->>BE: pwHash
  BE-->>FE: 200 + JWT
  FE-->>User: 대시보드 (토큰 저장)
```
---
## Epic 1 – 인증 ERD
```mermaid
erDiagram
  USER {
    bigint id
    varchar email
    varchar nickname
    varchar password_hash
    enum role
    datetime created_at
  }

  SOCIAL_ACCOUNT {
    bigint id
    enum provider
    varchar provider_user_id
    bigint user_id
    datetime created_at
  }

  USER ||--o{ SOCIAL_ACCOUNT : "1:N"

```
---
## Epic 2 – 커머스 ERD
```mermaid
erDiagram
  USER ||--o{ PRODUCT : "1 :N (seller)"
  USER ||--o{ ORDER : "1 :N (buyer)"

  PRODUCT {
    bigint id PK
    varchar name
    text description
    decimal price
    int stock
    bigint seller_id FK
    varchar image_urls
    datetime created_at
  }

  ORDER {
    bigint id PK
    bigint buyer_id FK
    decimal total_price
    varchar status
    datetime ordered_at
  }
  ORDER ||--o{ ORDER_ITEM : "1 :N"

  ORDER_ITEM {
    bigint id PK
    bigint order_id FK
    bigint product_id FK
    int quantity
    decimal unit_price
  }

```
---
## Sprint 1 (2025-04-23 ~ 2025-05-07) Gantt
```mermaid
gantt
  title Sprint 1 Timeline (2025-04-23 ~ 2025-05-07)
  dateFormat  YYYY-MM-DD

  section Sprint 1 (2주)
  FE_1_1_1_회원가입폼          :done,    task1, 2025-04-23, 5d
  BE_1_1_2_회원가입API         :done,    task2, after task1, 6d
  PM_1_1_3_QA_FAQ             :active,  task3, after task2, 2d
  FE_1_2_1_로그인UI            :active,  task4, 2025-05-03, 3d
  BE_1_2_2_JWTAPI              :         task5, after task4, 3d
  FE_1_3_1_소셜버튼            :         task6, 2025-05-06, 2d
  BE_1_3_3_OAuth2설정          :         task7, after task6, 2d
  PM_1_3_6_정책_QA             :         task8, after task7, 1d

```
