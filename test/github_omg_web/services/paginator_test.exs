defmodule GithubOmgWeb.PaginatorTest do
  use GithubOmgWeb.ConnCase
  alias GithubOmgWeb.Paginator

  describe "Test Paginator" do

    test "page 1 of 15" do
      res = Paginator.call %Paginator{total: 150}

      assert res.first == nil
      assert res.previous == nil
      assert res.next == 2
      assert res.last == 15
      assert res.pages == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end

    test "page 5 of 15" do
      res = Paginator.call %Paginator{page: 5, total: 150}

      assert res.first == 1
      assert res.previous == 4
      assert res.next == 6
      assert res.last == 15
      assert res.pages == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end

    test "page 6 of 15" do
      res = Paginator.call %Paginator{page: 6, total: 150}

      assert res.first == 1
      assert res.previous == 5
      assert res.next == 7
      assert res.last == 15
      assert res.pages == [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    end

    test "page 7 of 15" do
      res = Paginator.call %Paginator{page: 7, total: 150}

      assert res.pages == [3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    end

    test "page 13 of 15" do
      res = Paginator.call %Paginator{page: 13, total: 150}

      assert res.pages == [6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    end

    test "per page 50" do
      res = Paginator.call %Paginator{page: 25, per_page: 50, total: 2000}

      assert res.first == 1
      assert res.previous == 24
      assert res.next == 26
      assert res.last == 40
      assert res.pages == [21, 22, 23, 24, 25, 26, 27, 28, 29, 30]

    end

    test "last page" do
      res = Paginator.call %Paginator{page: 50, total: 500}

      assert res.first == 1
      assert res.previous == 49
      assert res.next == nil
      assert res.last == nil
    end

    test "max display" do
      res = Paginator.call %Paginator{page: 8, max_display: 5, total: 2000}

      assert res.first == 1
      assert res.previous == 7
      assert res.next == 9
      assert res.pages == [6, 7, 8, 9, 10]

      res = Paginator.call %Paginator{page: 9, max_display: 5, total: 2000}
      assert res.pages == [7, 8, 9, 10, 11]

    end

    test "max results - total more than max" do
      res = Paginator.call %Paginator{page: 96, total: 2000, max_results: 1000}

      assert res.last == 100
      assert res.pages == [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]

    end

    test "max results - max more than total" do
      res = Paginator.call %Paginator{page: 96, total: 2000, max_results: 1000}

      assert res.last == 100
      assert res.pages == [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
    end

    test "no pages - zero total" do
      res = Paginator.call %Paginator{total: 0}

      assert res.first == nil
      assert res.previous == nil
      assert res.next == nil
      assert res.pages == []
    end

    test "no pages - low total" do
      res = Paginator.call %Paginator{total: 5}

      assert res.first == nil
      assert res.previous == nil
      assert res.next == nil
      assert res.pages == []
    end
  end
end
