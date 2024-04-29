abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(dynamic id);

  Future<void> add(T newItem);
  Future<void> addAll(List<T> newItems);
  Future<void> update(T updatedItem);
  Future<void> delete(dynamic id);
}
