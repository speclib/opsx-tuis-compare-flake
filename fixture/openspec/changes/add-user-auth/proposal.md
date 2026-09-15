# Add user authentication

## Why

Everything in the product is currently anonymous, which makes per-user settings
and any audit trail impossible. Authentication is the smallest change that
unblocks both.

## What Changes

- Add sign-in with an email address and a password.
- Add a session that expires.
- Add a sign-out that ends the session immediately.

## Capabilities

### New Capabilities

- `user-auth`: who a user is, how they prove it, and how long that lasts.

### Modified Capabilities

None.

## Impact

- A new session store.
- Every existing screen gains a signed-in and a signed-out state.
