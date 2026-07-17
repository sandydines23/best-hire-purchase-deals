# besthirepurchasedeals.com

Static SEO satellite site — independent guide to Hire Purchase (HP) car finance in the UK.

## Structure

See `CLAUDE.md` in the parent `Satellites/` folder for the full architecture reference. In short:

- Edit files in `content/`, `components/`, `css/`, `js/`, `images/` only.
- Run `bash build.sh` after any change — it assembles `index.html`, `about/index.html`, `editorial-policy/index.html`, and `cookie-policy/index.html` from the header/footer/content pieces.
- Never hand-edit the built `index.html` files — they get overwritten on the next build.

## Deploying to Cloudflare Pages

1. Push this folder to a GitHub (or GitLab) repo.
2. In the Cloudflare dashboard: **Workers & Pages → Create → Pages → Connect to Git**, and select the repo.
3. Framework preset: **None** (this is a plain static site, no build step).
4. Build command: leave blank. Build output directory: `/` (project root, since `index.html` lives at the top level).
5. Deploy. Cloudflare Pages serves `index.html` at the domain root, so all `/css/...`, `/images/...`, `/js/...` absolute paths in the built pages resolve correctly out of the box — no extra config needed.
6. Add `besthirepurchasedeals.com` as a custom domain under the Pages project's **Custom domains** tab once you're ready to point it live. If the domain's DNS is already on Cloudflare, this is a one-click connect.

Alternatively, for a quick one-off deploy without Git, use Wrangler: `npx wrangler pages deploy .` from this folder.

## Status

- The "Best hire purchase deals" section (`#compare`) links out to `car-finance.co.uk/hp` as the featured comparison hub, plus a roundup of manufacturer and independent comparison sites (MoneySuperMarket, BMW, Toyota, cinch, MoneySavingExpert, Compare the Market). No other affiliate/lender partnership is live yet — update the footer + editorial policy disclosure if/when one is added.
- The eligibility-checklist section and the standalone contact page have been removed from the site. There is currently no contact page and no on-site eligibility/lead-capture flow.
- All other CTAs (`href="#"` inside the page, e.g. calculator buttons) remain anchor links to on-page sections, not external forms.
