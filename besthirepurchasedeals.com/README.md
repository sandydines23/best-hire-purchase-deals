# besthirepurchasedeals.com

Static SEO satellite site — independent guide to Hire Purchase (HP) car finance in the UK.

## Structure

See `CLAUDE.md` in the parent `Satellites/` folder for the full architecture reference. In short:

- Edit files in `content/`, `components/`, `css/`, `js/`, `images/` only.
- Run `bash build.sh` after any change — it assembles `index.html`, `about/index.html`, `contact/index.html`, `editorial-policy/index.html`, and `cookie-policy/index.html` from the header/footer/content pieces.
- Never hand-edit the built `index.html` files — they get overwritten on the next build.

## Deploying to Vercel

1. Push this folder to a GitHub repo (or drag-and-drop deploy via the Vercel dashboard).
2. In Vercel: **New Project → Import** the repo.
3. Framework preset: **Other** (this is a plain static site, no build command needed).
4. Build command: leave blank. Output directory: leave as project root (`.`).
5. Deploy. Vercel serves `index.html` at the domain root, so all `/css/...`, `/images/...`, `/js/...` absolute paths in the built pages resolve correctly out of the box.
6. Add `besthirepurchasedeals.com` as a custom domain in the Vercel project settings once you're ready to point DNS at it.

## Status

- Placeholder CTAs (`href="#"`) are used throughout for "See deal" buttons — there is no live affiliate/lender partnership yet. Swap these for real tracked links once a partner is onboarded, and update the footer + editorial policy disclosure at that point.
- Comparison table figures are illustrative examples, clearly labelled as such — not live rates.
- Contact page uses `mailto:` links (no backend/form processor wired up).
