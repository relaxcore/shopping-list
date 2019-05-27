# Project Setup
### Install Elixir
```shell
brew install elixir
```
### Clone the repository
```shell
git@ssh.hub.teamvoy.com:block_compare/test-task.git
cd test-task
```
### Update ENV variables
```shell
cp .env.example .env
# set all variables correctly
source .env
```
### Install dependencies and setup Ecto
```shell
mix deps.get
mix ecto.setup
```
### Start Your Pheonix server
```shell
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Endpoints

## All Items

**GET** `/api/v1/items`
  
**Params:**

`filter[category]` - category name

`filter[bought]` - true/false 

**Success Response:**

```json
{
  "data": [
    {
      "bought": false,
      "category": {
        "id": "d7c2f78f-c804-43d7-a20f-8c2ab8498fb7",
        "name": "Beverages"
      },
      "id": "631a4570-295c-4b0c-bc2d-4db0b5aace08",
      "name": "Coca-Cola",
      "price": 2.5
    }
  ]
}
```

## Show Item

**GET** `/api/v1/items/:item_id`

**Success Response:**

```json
{
  "data": {
    "bought": false,
    "category": {
      "id": "d7c2f78f-c804-43d7-a20f-8c2ab8498fb7",
      "name": "Beverages"
    },
    "id": "631a4570-295c-4b0c-bc2d-4db0b5aace08",
    "name": "Coca-Cola",
    "price": 2.5
  }
}
```

**Error Response:**

```json
{
  "errors": {
    "detail": "Not Found"
  }
}
```

## Create Item

**POST** `/api/v1/items`

**Params:**

`name` - item name

`price` - item price 

`category_id` - item category_id. Categories list with IDs you can find at `/api/v1/categories`

**Success Response:**

```json
{
  "data": {
    "bought": false,
    "category": {
      "id": "d7c2f78f-c804-43d7-a20f-8c2ab8498fb7",
      "name": "Beverages"
    },
    "id": "631a4570-295c-4b0c-bc2d-4db0b5aace08",
    "name": "Coca-Cola",
    "price": 2.5
  }
}
```

**Error Response:**

```json
{
  "errors": {
    "name": [
      "can't be blank"
    ],
    "price": [
      "can't be blank"
    ]
  }
}
```

## Update Item

**PUT** `/api/v1/items/:item_id`

All same as create action, except one extra param:

`bought` - true/false

## Delete Item

**DELETE** `/api/v1/items/:item_id`

**Success Response:**

`Status code 200 with no content`

**Error Response:**

```json
{
  "errors": {
    "detail": "Not Found"
  }
}
```
