(ns pawnshop.base62)

(defn base62-list [num]
  "Generates a list of integer representations of base62 numbers for indices into char sequence."
  (let [count62 (quot num 62)
        remain (rem num 62)]
    (if (> count62 0)
      (cons remain (base62-list count62))
      (if (> remain 0)
        (cons remain nil)
        '(0)))))

(def base62-vec
  "Generates the sequence of base62 digits, should run only once."
  (into [] (concat (range 0 10) (map char (concat (range 65 91) (range 97 123))))))

(defn base62 [num]
  "Given an integer, returns a base62 string representation."
  (let [indices (base62-list num)
        digits (map (fn [x] (nth base62-vec x)) indices)]
    (reduce
     (fn [acc, next] (str next acc))
     ""
     digits)))