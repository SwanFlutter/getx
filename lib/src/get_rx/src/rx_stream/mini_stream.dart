part of 'rx_stream.dart';

/// A node in a doubly linked list, used to store subscriptions.
class Node<T> {
  T? data;
  Node<T>? next;
  Node<T>? prev;
  Node({this.data, this.next, this.prev});
}

/// Represents a subscription to a MiniStream.
class MiniSubscription<T> {
  const MiniSubscription(this.data, this.onError, this.onDone, this.cancelOnError, this.listener);

  final OnData<T> data;
  final Function? onError;
  final Callback? onDone;
  final bool cancelOnError;
  final FastList<T> listener;

  /// Cancels the subscription and removes the listener.
  Future<void> cancel() async => listener.removeListener(this);
}

/// A minimal implementation of a stream with basic functionalities.
class MiniStream<T> {
  FastList<T> listenable = FastList<T>();
  late T _value;

  /// Gets the current value of the stream.
  T get value => _value;

  /// Sets a new value and notifies listeners.
  set value(T val) {
    add(val);
  }

  /// Adds a new event to the stream and notifies listeners.
  void add(T event) {
    _value = event;
    listenable._notifyData(event);
  }

  /// Adds an error to the stream and notifies listeners.
  void addError(Object error, [StackTrace? stackTrace]) {
    listenable._notifyError(error, stackTrace);
  }

  /// Gets the number of listeners.
  int get length => listenable.length;

  /// Checks if there are any listeners.
  bool get hasListeners => listenable.isNotEmpty;

  /// Checks if the stream is closed.
  bool get isClosed => _isClosed;

  /// Subscribes to the stream with the given callbacks.
  MiniSubscription<T> listen(void Function(T event) onData, {Function? onError, void Function()? onDone, bool cancelOnError = false}) {
    final subs = MiniSubscription<T>(
      onData,
      onError,
      onDone,
      cancelOnError,
      listenable,
    );
    listenable.addListener(subs);
    return subs;
  }

  bool _isClosed = false;

  /// Closes the stream and notifies listeners.
  void close() {
    if (_isClosed) {
      throw 'You cannot close a closed Stream';
    }
    listenable._notifyDone();
    listenable.clear();
    _isClosed = true;
  }
}

/// A fast list implementation for managing stream subscriptions.
class FastList<T> {
  Node<MiniSubscription<T>>? _head;
  Node<MiniSubscription<T>>? _tail;
  int _length = 0;

  /// Notifies all listeners with the given data.
  void _notifyData(T data) {
    var currentNode = _head;
    while (currentNode != null) {
      currentNode.data?.data(data);
      currentNode = currentNode.next;
    }
  }

  /// Notifies all listeners that the stream is done.
  void _notifyDone() {
    var currentNode = _head;
    while (currentNode != null) {
      currentNode.data?.onDone?.call();
      currentNode = currentNode.next;
    }
  }

  /// Notifies all listeners of an error.
  void _notifyError(Object error, [StackTrace? stackTrace]) {
    var currentNode = _head;
    while (currentNode != null) {
      currentNode.data?.onError?.call(error, stackTrace);
      currentNode = currentNode.next;
    }
  }

  /// Checks if the list is empty.
  bool get isEmpty => _length == 0;

  /// Checks if the list is not empty.
  bool get isNotEmpty => _length > 0;

  /// Gets the number of elements in the list.
  int get length => _length;

  /// Returns the element at the specified position.
  MiniSubscription<T>? elementAt(int position) {
    if (isEmpty || position < 0 || position >= _length) return null;

    var node = _head;
    var current = 0;

    while (current != position) {
      node = node!.next;
      current++;
    }
    return node!.data;
  }

  /// Adds a listener to the list.
  void addListener(MiniSubscription<T> data) {
    var newNode = Node(data: data);

    if (isEmpty) {
      _head = _tail = newNode;
    } else {
      _tail!.next = newNode;
      newNode.prev = _tail;
      _tail = newNode;
    }
    _length++;
  }

  /// Checks if the list contains the specified element.
  bool contains(T element) {
    var currentNode = _head;
    while (currentNode != null) {
      if (currentNode.data == element) return true;
      currentNode = currentNode.next;
    }
    return false;
  }

  /// Removes a listener from the list.
  void removeListener(MiniSubscription<T> element) {
    var currentNode = _head;
    while (currentNode != null) {
      if (currentNode.data == element) {
        _removeNode(currentNode);
        break;
      }
      currentNode = currentNode.next;
    }
  }

  /// Clears all elements from the list.
  void clear() {
    _head = _tail = null;
    _length = 0;
  }

  /// Removes a specific node from the list.
  void _removeNode(Node<MiniSubscription<T>> node) {
    if (node.prev == null) {
      _head = node.next;
    } else {
      node.prev!.next = node.next;
    }

    if (node.next == null) {
      _tail = node.prev;
    } else {
      node.next!.prev = node.prev;
    }

    _length--;
  }
}
