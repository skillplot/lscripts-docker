# Lscripts Docs (Chirpy)

This folder is a **Jekyll** site using the **Chirpy** theme (modern UX: dark mode, search, TOC, responsive layout).

## Local preview

Requirements:
- Ruby 3.x
- Bundler

```bash
cd docs
bundle install
bundle exec jekyll serve --livereload
```

## GitHub Pages deployment (recommended)

This repo includes a GitHub Actions workflow:

- `.github/workflows/pages-deploy.yml`

It builds the site from `/docs` and deploys it to GitHub Pages automatically.

### Custom domain

A `CNAME` file is included and preserved:

- `docs/CNAME` → `lscripts.skillplot.org`

> If you change the domain, update both `docs/CNAME` and `docs/_config.yml` (`url`).
