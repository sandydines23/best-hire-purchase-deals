#!/usr/bin/env bash
# ==========================================================================
# Build script for besthirepurchasedeals.com
# Assembles header + content + footer into static pages with relative paths.
# ==========================================================================
set -euo pipefail
cd "$(dirname "$0")"

HEADER="components/header.html"
FOOTER="components/footer.html"
SITE_URL="https://besthirepurchasedeals.com"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# build_page TITLE DESCRIPTION CANONICAL_PATH CONTENT_FILE OUTPUT_FILE ACTIVE_NAV DEPTH OG_TYPE EXTRA_CSS
build_page() {
  local TITLE="$1"
  local DESCRIPTION="$2"
  local CANONICAL_PATH="$3"   # e.g. "" or "about/"
  local CONTENT_FILE="$4"
  local OUTPUT_FILE="$5"
  local ACTIVE_NAV="$6"       # e.g. "/about/" or "" for none
  local DEPTH="$7"            # 0 or 1
  local OG_TYPE="$8"
  local EXTRA_CSS="${9:-}"    # e.g. "css/ranking.css" or ""

  local BASE=""
  local ROOT_HREF="/"
  if [ "$DEPTH" -eq 1 ]; then
    BASE="../"
    ROOT_HREF="../"
  fi

  local CANONICAL_URL="${SITE_URL}/${CANONICAL_PATH}"

  local TMP_HEADER="$TMP_DIR/header.html"
  local TMP_FOOTER="$TMP_DIR/footer.html"
  local TMP_CONTENT="$TMP_DIR/content.html"

  local NAV_SED=()
  if [ -n "$ACTIVE_NAV" ]; then
    NAV_SED=(-e "s|href=\"$ACTIVE_NAV\"|href=\"$ACTIVE_NAV\" class=\"active\"|g")
  fi

  sed \
    "${NAV_SED[@]}" \
    -e "s|href=\"/\"|href=\"${ROOT_HREF}\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    -e "s|src=\"/\([^\"]*\)\"|src=\"${BASE}\1\"|g" \
    "$HEADER" > "$TMP_HEADER"

  sed \
    -e "s|href=\"/\"|href=\"${ROOT_HREF}\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    -e "s|src=\"/\([^\"]*\)\"|src=\"${BASE}\1\"|g" \
    "$FOOTER" > "$TMP_FOOTER"

  sed \
    -e "s|href=\"/\"|href=\"${ROOT_HREF}\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    -e "s|src=\"/\([^\"]*\)\"|src=\"${BASE}\1\"|g" \
    "$CONTENT_FILE" > "$TMP_CONTENT"

  mkdir -p "$(dirname "$OUTPUT_FILE")"

  {
    cat <<HTML_HEAD
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${TITLE}</title>
<meta name="description" content="${DESCRIPTION}">
<link rel="canonical" href="${CANONICAL_URL}">
<meta property="og:type" content="${OG_TYPE}">
<meta property="og:title" content="${TITLE}">
<meta property="og:description" content="${DESCRIPTION}">
<meta property="og:url" content="${CANONICAL_URL}">
<meta property="og:site_name" content="Best Hire Purchase Deals">
<meta name="twitter:card" content="summary">
<link rel="icon" type="image/svg+xml" href="${BASE}images/logo.svg">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${BASE}css/global.css">
HTML_HEAD

    if [ -n "$EXTRA_CSS" ]; then
      echo "<link rel=\"stylesheet\" href=\"${BASE}${EXTRA_CSS}\">"
    fi

    cat <<HTML_BODY_OPEN
</head>
<body>
HTML_BODY_OPEN

    cat "$TMP_HEADER"
    echo "<main>"
    cat "$TMP_CONTENT"
    echo "</main>"
    cat "$TMP_FOOTER"

    cat <<HTML_TAIL
<script src="${BASE}js/nav.js"></script>
<script src="${BASE}js/app.js"></script>
</body>
</html>
HTML_TAIL
  } > "$OUTPUT_FILE"

  echo "Built: $OUTPUT_FILE"
}

# ---- Main ranking page (index) ----
build_page \
  "Best Hire Purchase Deals 2026 | Compare HP Car Finance UK" \
  "Compare hire purchase (HP) car finance deals, see representative APR examples, use our monthly payment calculator, and learn how HP compares to PCP." \
  "" \
  "content/main-ranking.html" \
  "index.html" \
  "" \
  0 \
  "article" \
  "css/ranking.css"

# ---- About ----
build_page \
  "About Us | Best Hire Purchase Deals" \
  "Best Hire Purchase Deals is an independent information site helping UK drivers understand hire purchase car finance." \
  "about/" \
  "content/about.html" \
  "about/index.html" \
  "/about/" \
  1 \
  "website"

# ---- Editorial policy ----
build_page \
  "Editorial Policy | Best Hire Purchase Deals" \
  "How we research, write, and review our hire purchase car finance guides — and how we handle independence and accuracy." \
  "editorial-policy/" \
  "content/editorial-policy.html" \
  "editorial-policy/index.html" \
  "" \
  1 \
  "website"

# ---- Contact ----
build_page \
  "Contact Us | Best Hire Purchase Deals" \
  "Get in touch with the Best Hire Purchase Deals team with questions, corrections, or partnership enquiries." \
  "contact/" \
  "content/contact.html" \
  "contact/index.html" \
  "/contact/" \
  1 \
  "website"

# ---- Cookie policy ----
build_page \
  "Cookie Policy | Best Hire Purchase Deals" \
  "Details on the cookies used on Best Hire Purchase Deals and how to manage them in your browser." \
  "cookie-policy/" \
  "content/cookie-policy.html" \
  "cookie-policy/index.html" \
  "" \
  1 \
  "website"

echo "Build complete."
