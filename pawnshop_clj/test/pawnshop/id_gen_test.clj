(ns pawnshop.id-gen-test
  (:use [clojure.test]
        [pawnshop.id-gen :as id-gen]))

(deftest id-sequencing
  (testing "A couple of calls to next-id"
    (is (= (id-gen/next-id 0) "000"))
    (is (= (id-gen/next-id 0) "100"))
    (is (= (id-gen/next-id 10) "20A"))
    (is (= (id-gen/next-id 620) "3A0"))))