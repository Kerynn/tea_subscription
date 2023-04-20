# Tea Subscription

The goal of this project is to create a backend API service that will be used by a frontend team to create a web application. The app will allow users to manage and view their tea subscriptions. This backend service will expose several endpoints for the frontend team to use that includes creating a new tea subscription, cancelling a subscription, and viewing all subscriptions (both currently active and cancelled).

## Getting Started

### Prerequisites

* Ruby 2.7.4
* Rails 5.2.8

### Setup

1. Fork and clone this repository.
2. `cd` into the root directory.
3. Run `bundle install`
4. Run `rails db:{drop,create,migrate}
5. To run the test suite, run `bundle exec rspec`
6. To run this server, enter `rails s`
7. You should now be able to hit the API endpoints using Postman or a similar tool.

## DB Schema

![Screen Shot 2023-04-19 at 4 09 54 PM](https://user-images.githubusercontent.com/111480866/233220171-e6bf73df-a617-4c3f-b51b-cf258ed92619.png)

## Endpoints

All endpoints start with url: http://localhost:3000

### Create Subscription

**Request:**
```
  POST "/api/v1/subscriptions"
  Content-Type: application/json
  Accept: application/json

  {
    "customer_id": 1,
    "tea_id": 3,
    "title": "Sunshine Spice",
    "price": 10.00
    "frequency": "monthly"
  }
```

**Response:**
```
  {
    "success": "Sunshine Spice Subscription created successfully for Charlie" 
  }
```

### Update Subscription (cancel or reactivate)

**Request:**
```
  PATCH "/api/v1/subscriptions/<subscription_id>?status=cancelled"
```

**Cancelled Response:**
```
  {
    "success": "Sunshine Spice subscription status updated successfully to cancelled"
  }
```

**Request:**
```
  PATCH "/api/v1/subscriptions/<subscription_id>?status=active"
```

**Reactivated Response:**
```
  {
    "success": "Sunshine Spice subscription status updated successfully to active"
  }
```

### View all Customer Subscriptions

**Request:**
```
  GET "/api/v1/subscriptions?customer_id=<customer_id>"
```

**Response:**
```
  {
    "data": [
        "id": 1,
        "type": "subscription",
        "attributes": {
              "tea_id": 1,
              "title": "Sunshine Spice",
              "price": 10.00,
              "status": "active",
              "frequency": "monthly"
        },
        "id": 2,
        "type": "subscription",
        "attributes": {
              "tea_id": 4,
              "title": "Morning Clouds",
              "price": 8.00,
              "status": "cancelled",
              "frequency": "weekly"
        },
    ]
  }
```

## Project Contributor

<div align="left">
  <img src="https://avatars.githubusercontent.com/u/111480866?v=4" alt="Profile" width="80" height="80">
  <p align="left">
    Kerynn Davis<br>
    <a href="https://www.linkedin.com/in/kerynn-davis/">LinkedIn Profile</a>
  </p>
</div>
