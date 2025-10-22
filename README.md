# Block Talk Smart Contract

A simple on-chain message board built with Clarity for the Stacks blockchain. Users can create, read, and delete posts. Each post is tied to the sender's principal and stored permanently unless deleted by the author.

## Features

- **Create Post:** Users can create a post with up to 200 UTF-8 characters.
- **Read Post:** Retrieve any post by its unique ID.
- **Delete Post:** Authors can delete their own posts.
- **Post Existence Check:** Verify if a post exists by ID.
- **Total Posts:** Query the total number of posts ever created.

## Data Structures

- **post-count:** Tracks the total number of posts.
- **posts map:** Stores each post with the following fields:
  - `id` (uint): Unique identifier for the post.
  - `sender` (principal): The author of the post.
  - `text` (string-utf8 200): The post content.
  - `block` (uint): Block height when the post was created.

## Public Functions

- `create-post (text (string-utf8 200))`: Create a new post.
- `get-post (id uint)`: Retrieve a post by ID.
- `get-total-posts`: Get the total number of posts.
- `delete-post (id uint)`: Delete a post (only by the author).
- `exists? (id uint)`: Check if a post exists.

## Usage

Deploy the contract to the Stacks blockchain using the Clarity CLI or your preferred development environment.

### Example: Creating a Post

```clarity
(create-post "Hello, Stacks!")
```

### Example: Reading a Post

```clarity
(get-post u1)
```

### Example: Deleting a Post

```clarity
(delete-post u1)
```

## Requirements

- [Stacks Blockchain](https://docs.stacks.co/)
- [Clarity Language](https://docs.stacks.co/write-smart-contracts/clarity-lang)

**Author:** Your Name  
**File:** `contracts/block-Talk.clar`
