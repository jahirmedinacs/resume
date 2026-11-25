# DEPRECATED: Jahir Medina Resume (Jekyll site)

> Review document. Describes everything in this repository on `master` (commit `06f87b9`) and how it works, so it can be archived. Not yet committed or moved to an archive branch.

## 1. What this repo is

A static resume website, built with **Jekyll** and hosted on **GitHub Pages** at `cv.jahirmedina.com` (see `CNAME`). It is a hard fork of [sproogen/modern-resume-theme](https://github.com/sproogen/modern-resume-theme) (MIT). The footer says so.

All personal content lives in YAML files under `_data/` and in `_config.yml`. The HTML layout and CSS come from the local `_layouts/`, `_includes/`, `_sass/` and `assets/` folders.

## 2. Repository inventory

### Root files

| Path | Purpose |
|---|---|
| `_config.yml` | Site settings: name, title, contact info, phone list, social usernames, About text, section titles, footer flag, Sass settings, `jekyll-seo-tag` plugin. Sets `theme: jekyll-theme-dinky`. |
| `index.md` | The only page. Front matter `layout: default`, empty body. All content comes from the layout. |
| `CNAME` | Custom domain: `cv.jahirmedina.com`. |
| `Gemfile` | `source rubygems` + `gemspec`. Pulls in the theme gem's dependencies. |
| `modern-resume-theme.gemspec` | Gem definition for the upstream theme. Depends on `github-pages ~> 209`, `jekyll-seo-tag ~> 2.1`, dev-depends on `html-proofer ~> 3.9`. Packages `assets`, `_layouts`, `_includes`, `_sass`, `LICENSE`, `README`. |
| `lib/modern-resume-theme/version.rb` | Gem version constant: `1.3.0`. |
| `.ruby-version` | `2.7.0`. |
| `.travis.yml` | Upstream CI config: build, htmlproofer, gem release. See section 6. |
| `README.md` | Contains **unresolved git merge conflict markers** (see section 7). Mostly upstream theme docs. |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `LICENSE` | Upstream project files (MIT license, contribution guide, Contributor Covenant). |
| `screenshot.png` | Screenshot of the upstream theme. Used in the upstream README. |
| `.gitignore` | Ignores `*.gem`, `.bundle`, `.sass-cache`, `_site`, `Gemfile.lock`, `vendor`, `.idx/` (Firebase Studio), `*.code-workspace`. |
| `.idea/` | JetBrains IDE project files (committed). |
| `.github/ISSUE_TEMPLATE/` | `bug_report.md` and `feature_request.md`, copied from upstream. |

### `_config.yml` sections

- **Personal info:** `name`, `full_name`, `title`, `email`, `phone_number` (list of `{tag, value, whatsapp, telegram, telegramuser}`), `website` (commented out).
- **Social:** `github_username`, `linkedin_username` are active. Others (`twitter`, `dribbble`, `facebook`, `flickr`, `instagram`, `pinterest`, `youtube`, `googleplus`) are commented out. The header renders an icon only for each username that is set.
- **Section titles:** `about_title`, `experience_title`, `programing_languages_title`, `projects_title`, `educaton_title` (typo), `languages_title`, `academic_experience_title`, `social_responsibilities_title`, `more_title` (commented out).
- **About:** `about_profile_image` (`/assets/cv-firstplane.jpg`), `about_content` (Markdown bio).
- **Footer:** `footer_show_references: true` ("References on request").
- **Build:** `sass` (`_sass`, compressed), plugin `jekyll-seo-tag`.

### Layouts and includes

| File | Role |
|---|---|
| `_layouts/default.html` | Page skeleton. Includes `head`, `header`, then each section (only if its data exists), then `footer`. Renders the `javascript.html` include inside an HTML comment, so it is **disabled**. |
| `_includes/head.html` | `<head>`: charset, viewport, `<title>` from `site.name` and `site.title`, `jekyll-seo-tag`, `/assets/main.css`, favicon, CDN scripts (jQuery 3.6.0, jsPDF 1.3.4, html2pdf 0.10.1 with SRI hash, Font Awesome kit), `/assets/main.js`, Google Analytics (production only, and only if `site.google_analytics` is set). |
| `_includes/header.html` | Name, full name, title. Right column: social icon buttons, a "print as PDF" button (calls `printWeb()`, which runs `window.print()`), email, phone numbers with WhatsApp/Telegram links, website. |
| `_includes/about.html` | Bio card with profile image and "Hide/Show" button. |
| `_includes/experience.html` | Renders `site.data.experience`. Company, job title, dates, optional logo, quote, Markdown description. |
| `_includes/programing_languages.html` | Renders `site.data.programing_languages`. **Bug:** reads `experience.*` variables, not `programing_language.*`, so entries render empty (see section 7). |
| `_includes/projects.html` | Renders `site.data.projects`. Name, link, GitHub icon, quote, description. |
| `_includes/education.html` | Renders `site.data.education`. Institution, qualification, dates, optional logo, quote, description. |
| `_includes/languages.html` | Renders `site.data.languages`. Name, level, dates, logo, quote, description. |
| `_includes/academic_experience.html` | Renders `site.data.academic_experience` (events, courses, conferences). |
| `_includes/social_responsibilities.html` | Renders `site.data.social_responsibilities` (groups, commissions, assemblies). |
| `_includes/more.html` | Free-text section from `site.more_content` (currently commented out in `_config.yml`, so hidden). |
| `_includes/footer.html` | Name, email, "References on request", and credit to the upstream theme. |
| `_includes/google-analytics.html` | Analytics snippet. Respects Do Not Track. Dormant (no `google_analytics` key). |
| `_includes/javascript.html` | html2pdf-based PDF generator (`#generatePDF` click handler, A4 output). **Not included** because the layout comments it out. The header button uses `window.print()` instead. |

### Data files (`_data/`)

Each file is a YAML list. Sections render only when their list is non-empty.

| File | Status | Content |
|---|---|---|
| `experience.yml` | **Active** | Work history (NTTData, Delaware Peru, Data Science Research Perú). |
| `education.yml` | **Active** | UNSM (thesis), UNT (BSc Computer Science), ICMC-USP (exchange). |
| `languages.yml` | **Active, wrong content** | Language entries (Spanish, English, Portuguese, French). **Copy-pasted from `education.yml`:** the descriptions and logos are education details, not language details. |
| `projects.yml` | **Template only** | Placeholder "Project name" entry. Renders as a placeholder on the live site. |
| `programing_languages.yml` | **Template only** | Placeholder "Company name" entry, consumed by a broken include. |
| `academic_experience.yml` | **Active** | Academic events, courses and conferences at UNT and related events. |
| `social_responsibilities.yml` | **Active** | MGiSE, Videogames Development Group, UNT commissions and assembly roles. |
| `__experience.yml` | **Template** (not used) | Experience template. No layout reads `site.data.__experience`, so it has no effect. |

Field schema (shared by most data files):

```yaml
- name / company        # display name (education, projects, languages use name; experience uses company)
  job_title / qualification / level   # subtitle line
  dates                 # free text
  link                  # optional; rendered as https:// (or http:// in some includes)
  github                # projects only; GitHub owner/repo
  ref_img               # optional logo URL
  quote                 # optional short line, rendered as <p class="quote">
  description: |        # Markdown, rendered with markdownify
```

The `_test/` folder has a parallel set of sample data files and a `_test/_config.yml`. Those are used only by the CI build (section 6).

### Styles and scripts

| File | Purpose |
|---|---|
| `assets/main.scss` | Entry Sass file. Imports `base`, `button`, `type`, plus icon and header styles. Compiles to `/assets/main.css`. |
| `_sass/base.scss` (241 lines) | Layout, grid, colors, print styles (`.no-print`, `col-print-*`). |
| `_sass/button.scss` (66 lines) | Round icon-button styles (`.button--sacnite`, `.button--round-l`). |
| `_sass/type.scss` (84 lines) | Typography. |
| `assets/main.js` | `hideComponent(id)` toggles a section and its `no-print` class. `printWeb()` calls `window.print()`. |
| `assets/cv-firstplane.jpg`, `assets/cv-front.jpg` | Profile and CV photos used on the site. |

### Test site

| Path | Purpose |
|---|---|
| `_test/_config.yml` | Upstream sample config. Sets `data_dir: _test/_data` and includes `_test`. |
| `_test/_data/*.yml` | Sample data (Institution 1/2, Company 1/2, Project 1/2). |
| `_test/images/travis.png` | Sample profile image. |

## 3. How it works

### Build pipeline (GitHub Pages)

1. Pushing to `master` triggers a GitHub Pages build, which runs Jekyll.
2. Jekyll reads `_config.yml`, then `index.md`, which uses `layout: default`.
3. The layout includes each section. Each include loops over one `site.data.<name>` list and prints an HTML row per entry.
4. Each `description`, `bio`, and `more_content` field passes through `markdownify`.
5. The Sass in `assets/main.scss` compiles to `/assets/main.css` (compressed).
6. Output is served from `cv.jahirmedina.com` via `CNAME`.

### Runtime behavior (in the browser)

- **Hide/Show buttons:** `hideComponent(id)` toggles `display` on a section and adds or removes `no-print` on its parent, so hidden sections also stay out of the print view.
- **PDF / print button:** calls `window.print()`. The browser's print dialog produces the PDF. The html2pdf generator in `javascript.html` is disabled.
- **Contact links:** phone numbers link to `tel:` and to WhatsApp (`wa.me`) and Telegram (`t.me`) when the matching flags are set.
- **Analytics:** only when built in production with `google_analytics` set. Not set here.
- **External scripts:** jQuery, jsPDF, html2pdf, Font Awesome kit. The Font Awesome kit is loaded with a hard-coded kit ID.

### Editing workflow

1. Edit the YAML in `_data/` or the fields in `_config.yml`.
2. Optional local preview: `bundle install` then `bundle exec jekyll serve` (see `README.md`).
3. Commit and push to `master`. GitHub Pages rebuilds and republishes.

## 4. Branches

| Branch | Last commit | What it contains |
|---|---|---|
| `master` (default) | `06f87b9`, "Firebase Studio idx ignored" | The live site (this document describes it). |
| `develop` | 2018-12-02 | Upstream theme development. Old and unrelated to the live CV. |
| `gh-pages` | 2018-11-20 | Old upstream demo site. A very early copy of the layout with a `profile.jpg`. |
| `LaTeX` | 2025-06-06 | ATS-friendly LaTeX CV in `CV_LaTeX/` (`main_cv.tex`, 20 section files, compiled PDF). **Separate CV track, not the Jekyll site.** |
| `LaTeX-MicrosoftFocus` | 2026-01-03 | Variant of the LaTeX CV tuned for a Microsoft-focused job description. |
| `LaTeX-Principal` | 2025-12-31 | Another LaTeX CV variant ("First Commit"). |

**Note:** if you archive this repo, the three `LaTeX*` branches hold a different product (the PDF CVs). Decide whether they go to the archive too.

## 5. Scripts

| File | Used by | Purpose |
|---|---|---|
| `scripts/bump-version.sh` | Travis, `before_install` | On `master` (not a PR): reads the gem version, bumps it if it already has a tag, creates a git tag, pushes the tag. |
| `scripts/merge-downstream.sh` | Travis, `after_success` | On `master`: merges `master` into `develop`. On conflict, creates a `merge-conflict-*` branch and opens a PR against `develop`. |

Both scripts assume Travis CI environment variables (`TRAVIS_BRANCH`, `TRAVIS_PULL_REQUEST`, `GITHUB_TOKEN`, `RUBYGEMS_TOKEN`). They are only useful for the upstream gem release process, not for hosting this CV.

## 6. CI / release (`.travis.yml`)

- Runs on `master` and `develop`, Ruby `2.4.2`.
- Builds `_test/_config.yml` with Jekyll, then runs `htmlproofer ./_site --disable-external`.
- On `master`: runs the bump and merge scripts, builds the gem, publishes to RubyGems and creates a GitHub release.
- The `.travis.yml` file is inherited from upstream. Travis CI's `travis-ci.org` service has been retired, so this pipeline most likely does not run here. GitHub Pages builds the live site without it.

## 7. Known issues found during this review

These are the issues you should know about before archiving. None were fixed in this pass.

1. **Merge conflict markers in `README.md`** (lines 1 and 160). Upstream README and the GitHub Pages template are both still present.
2. **Conflict markers in `_config.yml`** are commented out (`#<<<<<<< HEAD`, `#=======`, `#>>>>>>> …`). Harmless to the build, but messy. `theme: jekyll-theme-dinky` is set above them.
3. **`programing_languages.html` reads the wrong variables** (`experience.*` instead of `programing_language.*`). Because `_data/programing_languages.yml` is a non-empty placeholder list, the live page shows the "Programing Languages and Technical Tools" heading followed by a blank row.
4. **`_config.yml` key typo:** `educaton_title` is set, but `education.html` reads `education_title`. The default "Education" is shown either way, so the page looks correct, but the setting is ignored.
5. **`_data/languages.yml` is copy-pasted from `education.yml`.** Descriptions and logos are for universities, not languages. The live site shows wrong text.
6. **`_data/projects.yml` and `_data/programing_languages.yml`** still contain template placeholders. `projects.yml` renders a "Project name" entry on the live page.
7. **`_includes/education.html`, `experience.html` and `languages.html`** add an `<hr></hr>` tag after each row (invalid HTML, since `<hr>` is a void element).
8. **Unused PDF generator.** `_includes/javascript.html` (html2pdf) is commented out in the layout. The PDF button calls `window.print()`. The `CV_Jahir-Medina` filename logic is dead code.
9. **Ruby version mismatch:** `.travis.yml` says `2.4.2`, `.ruby-version` says `2.7.0`, and the gemspec says `~> 2.0`. Matters only if you run the build locally.
10. **Personal data committed:** email, phone numbers (with WhatsApp/Telegram handles) and social usernames live in `_config.yml`. Those are visible on the public site, which is the intent, but they also sit in git history after archiving.
11. **External dependencies without a pin check:** jQuery, jsPDF, html2pdf and the Font Awesome kit load from CDNs on every page view.

## 8. Archive checklist (once reviewed)

- [ ] Review this document and mark the items you want fixed or kept.
- [ ] Decide whether to keep the live CV hosted (`cv.jahirmedina.com` is served from `master`). If so, do not archive `master` until the domain is moved or retired.
- [ ] Create an archive branch, for example `archive/jekyll-resume-2026`, from `master`, and commit this file there.
- [ ] Decide what to do with the `LaTeX`, `LaTeX-MicrosoftFocus` and `LaTeX-Principal` branches.
- [ ] Decide what to do with `develop` and `gh-pages`. They are upstream leftovers from 2018.
- [ ] Disable GitHub Pages for the repo (or point `CNAME` elsewhere) if the site is retired.
- [ ] Set the archive branch as the repo default, or tag `master` before retiring it.
