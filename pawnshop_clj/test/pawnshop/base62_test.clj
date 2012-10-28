(ns pawnshop.base62-test
  (:use [clojure.test]
        [pawnshop.base62]))

(deftest base62-output
  (testing "Output of base62 functions agrees with contract define for Erlang version"
    (is (= (base62 620) "A0"))
    (is (= (base62 0) "0"))
    (is (= (base62 36) "a"))))