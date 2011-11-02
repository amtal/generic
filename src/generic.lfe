(include-lib "lfe_utils/include/all.lfe")
(defmodule generic
  (using lists)
  (export (children 1) (family 1)))

;; Any tagged tuple works. Tag doesn't have to be atom.
;;
;; Lists also work. This is... Improper, since you can't tell one list
;; from another. You can't do generic programming on just lists. It
;; does, however, simplify implementation.
;;
;; I'm not going to mention their appearance in documentation. The raw
;; output of stuff like children/1 is never seen, anyway, it should
;; immediately be consumed by a partial match.
(defn data? 
  [xs] (when (is_list xs)) 
    'true
  [tup] (when (is_tuple tup) (> (tuple_size tup) 1))
    'true
  [_] 
    'false)

;; The important thing is to only traverse data types, ignore everything
;; else. Returning just numbers or binaries doesn't give enough
;; information to match on to do interesting things.
;;
;; The 'lists are data types' thing is annoying, because they're not
;; interesting, but I'd have to complicate the implementation with extra
;; private functions... Feh.
(defn children
  [xs] (when (is_list xs)) 
    (lists:filter (fun data? 1) xs)
  [tup] (when (is_tuple tup) (> (tuple_size tup) 1))
    (-> (tuple_to_list tup)
        tl
        (lists:filter (fun data? 1) <>))
  [_] '())

(defn family [term]
  (-> (children term)
      (lists:map (fun family 1) <>)
      lists:append
      (cons term <>)))
