(deftheme me
  "Created 2020-06-11.")

(custom-theme-set-faces
 'me
 '(cursor ((t (:background "#181818"))))
 '(highlight ((t (:background "#a1b56c"))))
 '(region ((t (:extend t :background "#b8b8b8" :distant-foreground "gtk_selection_fg_color"))))
 '(secondary-selection ((t (:extend t :background "#f7ca88"))))
 '(trailing-whitespace ((t (:background "#ab4642"))))
 '(button ((t (:inherit (link)))))
 '(link ((t (:underline (:color foreground-color :style line) :foreground "RoyalBlue3"))))
 '(link-visited ((t (:foreground "magenta4" :inherit (link)))))
 '(fringe ((((class color) (background light)) (:background "grey95")) (((class color) (background dark)) (:background "grey10")) (t (:background "green"))))
 '(header-line ((t (:box nil :foreground "black" :background "#a1b56c"))))
 '(tooltip ((t (:foreground "black" :background "lightyellow" :inherit (variable-pitch)))))
 '(isearch ((t (:background "#ba8baf" :foreground "lightskyblue1"))))
 '(isearch-fail ((((class color) (min-colors 88) (background light)) (:background "RosyBrown1")) (((class color) (min-colors 88) (background dark)) (:background "red4")) (((class color) (min-colors 16)) (:background "red")) (((class color) (min-colors 8)) (:background "red")) (((class color grayscale)) (:foreground "grey")) (t (:inverse-video t))))
 '(lazy-highlight ((t (:background "#86c1b9"))))
 '(match ((t (:background "#f7ca88"))))
 '(next-error ((t (:inherit (region)))))
 '(query-replace ((t (:background "#ba8baf" :foreground "lightskyblue1"))))
 '(mode-line ((t (:box (:line-width 2 :color "#a1b56c") :foreground "black" :background "#a1b56c"))))
 '(mini-modeline-mode-line ((t (:background "#a1b56c" :height 0.15))))
 '(mode-line-emphasis ((t (:weight bold))))
 '(term-color-white ((t (:background "white" :foreground "white"))))
 '(term-color-black ((t (:background "#181818" :foreground "#181818"))))
 '(term-color-red ((t (:background "#ab4642" :foreground "#ab4642"))))
 '(term-color-yellow ((t (:background "#f7ca77" :foreground "#f7ca88"))))
 '(term-color-green ((t (:background "#a1b56c" :foreground "#a1b56c"))))
 '(term-color-cyan ((t (:background "#86c1b9" :foreground "#86c1b9"))))
 '(term-color-blue ((t (:background "#7cafc2" :foreground "#7cafc2"))))
 '(term-color-magenta ((t (:background "#ba8baf" :foreground "#ba8baf")))))

(provide-theme 'me)