# Design: dark mode

## Following the system preference

The preference is read once at startup and then watched, rather than polled, so
that a user switching their desktop theme sees the change without restarting.

Three states are needed, not two: light, dark, and follow-the-system. Storing
only a boolean would lose the difference between a user who chose light and a
user who never chose anything, and those want different behaviour when the
system preference changes.

## Contrast is checked per theme, not per pairing

The theming capability already refuses a pairing below the contrast floor. The
dark theme is checked once when it is defined rather than on every render,
because the palette is fixed at build time.
