(ns pawnshop.id-gen
  (:use [pawnshop.base62 :only  (base62)]))

(def current-sequence (atom -1))

(defn- proper-node-id [id]
  "Converts the given integer into a base-62 node ID for ID generation."
  (let [id-str (base62 id)]
    (if (= (.length id-str) 1)
      (str "0" id-str)
      id-str)))

(defn init-sequence [init]
  "Sets the sequence starting point to the given integer."
  (swap! current-sequence #(init)))

(defn- next-sequence-id []
  "Increments and retrieves the current sequence number."
  (swap! current-sequence #(+ 1 %1)))

(defn next-id [node-id]
  "Returns the base-62 representation of the current sequence with node ID."
  (let [id (base62 (next-sequence-id))
        node-id-str (proper-node-id node-id)]
    (str id node-id-str)))