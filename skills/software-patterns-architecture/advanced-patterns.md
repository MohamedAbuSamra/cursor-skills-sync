# Advanced Patterns & Architectures

Detailed reference for advanced architectural patterns and system design concepts.

## Advanced Architectural Patterns

### Event Sourcing + CQRS

**Event Sourcing:**
- Store all changes as a sequence of events
- Reconstruct state by replaying events
- Complete audit trail
- Time travel debugging

**Implementation:**
```typescript
// Event store
interface Event {
  id: string;
  type: string;
  aggregateId: string;
  data: any;
  timestamp: Date;
}

// Aggregate
class Order {
  private events: Event[] = [];
  
  createOrder(data: CreateOrderData) {
    this.apply(new OrderCreatedEvent(data));
  }
  
  private apply(event: Event) {
    this.events.push(event);
    // Update state based on event
  }
  
  getEvents(): Event[] {
    return [...this.events];
  }
}

// Read model projection
class OrderReadModel {
  async project(event: Event) {
    switch (event.type) {
      case 'OrderCreated':
        await this.createOrderView(event.data);
        break;
      // ... other events
    }
  }
}
```

### Reactive Architecture

**Principles:**
- Responsive: System responds in timely manner
- Resilient: Handles failures gracefully
- Elastic: Scales up/down as needed
- Message-driven: Async message passing

**Implementation:**
```typescript
// Reactive streams with backpressure
class EventStream {
  private subscribers: Subscriber[] = [];
  
  subscribe(subscriber: Subscriber) {
    this.subscribers.push(subscriber);
  }
  
  async publish(event: Event) {
    // Handle backpressure
    const promises = this.subscribers.map(sub => 
      sub.onNext(event).catch(err => this.handleError(err))
    );
    await Promise.allSettled(promises);
  }
}
```

### Multi-Tenancy Patterns

**Data Isolation:**
- Separate databases per tenant
- Shared database with tenant ID
- Hybrid approach

**Implementation:**
```typescript
// Tenant context
class TenantContext {
  private tenantId: string;
  
  getTenantId(): string {
    return this.tenantId;
  }
  
  // Middleware to extract tenant from request
  static middleware(req: Request, res: Response, next: NextFunction) {
    const tenantId = req.headers['x-tenant-id'];
    req.tenantContext = new TenantContext(tenantId);
    next();
  }
}

// Repository with tenant isolation
class TenantAwareRepository<T> {
  async findAll(tenantId: string): Promise<T[]> {
    return this.db.query(
      'SELECT * FROM table WHERE tenant_id = ?',
      [tenantId]
    );
  }
}
```

### API Gateway / BFF Pattern

**Backend-for-Frontend (BFF):**
- Tailor backend responses per frontend
- Aggregate multiple services
- Reduce frontend complexity

**Implementation:**
```typescript
// BFF service
class DashboardBFF {
  constructor(
    private userService: UserService,
    private orderService: OrderService,
    private notificationService: NotificationService
  ) {}
  
  async getDashboardData(userId: string) {
    // Aggregate data from multiple services
    const [user, orders, notifications] = await Promise.all([
      this.userService.getUser(userId),
      this.orderService.getUserOrders(userId),
      this.notificationService.getUserNotifications(userId)
    ]);
    
    // Transform for frontend
    return {
      user: this.transformUser(user),
      orders: this.transformOrders(orders),
      notifications: this.transformNotifications(notifications)
    };
  }
}
```

## Advanced Design Patterns

### Pipeline / Chain of Responsibility

**Implementation:**
```typescript
interface Middleware<T> {
  process(data: T, next: (data: T) => Promise<T>): Promise<T>;
}

class ValidationMiddleware implements Middleware<Request> {
  async process(req: Request, next: (req: Request) => Promise<Response>) {
    if (!this.validate(req)) {
      throw new ValidationError();
    }
    return next(req);
  }
}

class AuthenticationMiddleware implements Middleware<Request> {
  async process(req: Request, next: (req: Request) => Promise<Response>) {
    if (!this.isAuthenticated(req)) {
      throw new AuthenticationError();
    }
    return next(req);
  }
}

// Pipeline execution
class Pipeline {
  private middlewares: Middleware<any>[] = [];
  
  use(middleware: Middleware<any>) {
    this.middlewares.push(middleware);
  }
  
  async execute(data: any) {
    let index = 0;
    const next = async (currentData: any): Promise<any> => {
      if (index >= this.middlewares.length) {
        return currentData;
      }
      const middleware = this.middlewares[index++];
      return middleware.process(currentData, next);
    };
    return next(data);
  }
}
```

### Plugin / Extension Pattern

**Implementation:**
```typescript
interface Plugin {
  name: string;
  initialize(context: PluginContext): void;
  execute(data: any): Promise<any>;
}

class PluginManager {
  private plugins: Map<string, Plugin> = new Map();
  
  register(plugin: Plugin) {
    this.plugins.set(plugin.name, plugin);
  }
  
  async executePlugin(name: string, data: any) {
    const plugin = this.plugins.get(name);
    if (!plugin) {
      throw new Error(`Plugin ${name} not found`);
    }
    return plugin.execute(data);
  }
  
  async executeAll(data: any) {
    const results = await Promise.all(
      Array.from(this.plugins.values()).map(plugin => 
        plugin.execute(data).catch(err => {
          console.error(`Plugin ${plugin.name} failed:`, err);
          return null;
        })
      )
    );
    return results.filter(r => r !== null);
  }
}
```

### Functional Patterns

**Monads:**
```typescript
// Maybe/Option monad
class Maybe<T> {
  private constructor(private value: T | null) {}
  
  static of<T>(value: T | null): Maybe<T> {
    return new Maybe(value);
  }
  
  map<U>(fn: (value: T) => U): Maybe<U> {
    return this.value === null 
      ? Maybe.of<U>(null)
      : Maybe.of(fn(this.value));
  }
  
  flatMap<U>(fn: (value: T) => Maybe<U>): Maybe<U> {
    return this.value === null 
      ? Maybe.of<U>(null)
      : fn(this.value);
  }
  
  getOrElse(defaultValue: T): T {
    return this.value ?? defaultValue;
  }
}

// Usage
const result = Maybe.of(user)
  .map(u => u.email)
  .map(email => email.toUpperCase())
  .getOrElse('no-email@example.com');
```

**Immutability:**
```typescript
// Immutable updates
function updateUser(user: User, updates: Partial<User>): User {
  return {
    ...user,
    ...updates,
    // Deep copy nested objects
    address: updates.address ? { ...user.address, ...updates.address } : user.address
  };
}

// Immutable collections
class ImmutableList<T> {
  private constructor(private items: readonly T[]) {}
  
  static of<T>(items: T[]): ImmutableList<T> {
    return new ImmutableList([...items]);
  }
  
  push(item: T): ImmutableList<T> {
    return new ImmutableList([...this.items, item]);
  }
  
  map<U>(fn: (item: T) => U): ImmutableList<U> {
    return new ImmutableList(this.items.map(fn));
  }
}
```

## Observability Patterns

**Structured Logging:**
```typescript
interface LogContext {
  requestId: string;
  userId?: string;
  tenantId?: string;
  [key: string]: any;
}

class Logger {
  info(message: string, context: LogContext) {
    console.log(JSON.stringify({
      level: 'info',
      message,
      timestamp: new Date().toISOString(),
      ...context
    }));
  }
  
  error(message: string, error: Error, context: LogContext) {
    console.error(JSON.stringify({
      level: 'error',
      message,
      error: {
        name: error.name,
        message: error.message,
        stack: error.stack
      },
      timestamp: new Date().toISOString(),
      ...context
    }));
  }
}
```

**Metrics:**
```typescript
class MetricsCollector {
  private counters: Map<string, number> = new Map();
  private histograms: Map<string, number[]> = new Map();
  
  incrementCounter(name: string, labels?: Record<string, string>) {
    const key = this.buildKey(name, labels);
    this.counters.set(key, (this.counters.get(key) || 0) + 1);
  }
  
  recordHistogram(name: string, value: number, labels?: Record<string, string>) {
    const key = this.buildKey(name, labels);
    const values = this.histograms.get(key) || [];
    values.push(value);
    this.histograms.set(key, values);
  }
  
  private buildKey(name: string, labels?: Record<string, string>): string {
    if (!labels) return name;
    const labelStr = Object.entries(labels)
      .map(([k, v]) => `${k}=${v}`)
      .join(',');
    return `${name}{${labelStr}}`;
  }
}
```

**Distributed Tracing:**
```typescript
class TraceContext {
  private traceId: string;
  private spanId: string;
  private parentSpanId?: string;
  
  static fromHeaders(headers: Record<string, string>): TraceContext {
    return new TraceContext(
      headers['x-trace-id'] || this.generateId(),
      headers['x-span-id'] || this.generateId(),
      headers['x-parent-span-id']
    );
  }
  
  createChildSpan(): TraceContext {
    return new TraceContext(
      this.traceId,
      this.generateId(),
      this.spanId
    );
  }
  
  toHeaders(): Record<string, string> {
    return {
      'x-trace-id': this.traceId,
      'x-span-id': this.spanId,
      ...(this.parentSpanId && { 'x-parent-span-id': this.parentSpanId })
    };
  }
  
  private static generateId(): string {
    return Math.random().toString(36).substring(2, 15);
  }
}
```

## Testing Patterns

**Property-Based Testing:**
```typescript
// Using a property-based testing library
import { fc } from 'fast-check';

test('addition is commutative', () => {
  fc.assert(
    fc.property(fc.integer(), fc.integer(), (a, b) => {
      return add(a, b) === add(b, a);
    })
  );
});
```

**Contract Testing:**
```typescript
// Consumer contract
interface UserServiceContract {
  getUser(id: string): Promise<User>;
}

// Provider implementation test
describe('UserService Provider', () => {
  it('satisfies consumer contract', async () => {
    const service = new UserService();
    const user = await service.getUser('123');
    
    // Verify contract
    expect(user).toHaveProperty('id');
    expect(user).toHaveProperty('email');
    expect(user).toHaveProperty('name');
  });
});
```

## Concurrency Patterns

**Actor Model:**
```typescript
interface ActorMessage {
  type: string;
  payload: any;
}

class Actor {
  private messageQueue: ActorMessage[] = [];
  private processing = false;
  
  async send(message: ActorMessage) {
    this.messageQueue.push(message);
    if (!this.processing) {
      this.process();
    }
  }
  
  private async process() {
    this.processing = true;
    while (this.messageQueue.length > 0) {
      const message = this.messageQueue.shift();
      await this.handle(message!);
    }
    this.processing = false;
  }
  
  protected async handle(message: ActorMessage) {
    // Override in subclasses
  }
}
```

**Queue-Based Processing:**
```typescript
class JobQueue {
  private queue: Job[] = [];
  private workers: Worker[] = [];
  private maxWorkers: number;
  
  constructor(maxWorkers: number = 5) {
    this.maxWorkers = maxWorkers;
  }
  
  async enqueue(job: Job) {
    this.queue.push(job);
    this.processQueue();
  }
  
  private async processQueue() {
    while (this.workers.length < this.maxWorkers && this.queue.length > 0) {
      const job = this.queue.shift();
      if (job) {
        const worker = this.processJob(job);
        this.workers.push(worker);
        worker.finally(() => {
          this.workers = this.workers.filter(w => w !== worker);
          this.processQueue();
        });
      }
    }
  }
  
  private async processJob(job: Job): Promise<void> {
    try {
      await job.execute();
    } catch (error) {
      await job.handleError(error);
    }
  }
}
```

## Data Patterns

**Eventual Consistency:**
```typescript
class EventualConsistentStore {
  private localState: Map<string, any> = new Map();
  private pendingUpdates: Update[] = [];
  
  async update(key: string, value: any) {
    // Optimistic update
    this.localState.set(key, value);
    this.pendingUpdates.push({ key, value, timestamp: Date.now() });
    
    // Sync in background
    this.sync().catch(err => {
      // Handle conflict resolution
      this.resolveConflict(key, err);
    });
  }
  
  private async sync() {
    const updates = [...this.pendingUpdates];
    this.pendingUpdates = [];
    
    for (const update of updates) {
      await this.remoteStore.update(update.key, update.value);
    }
  }
  
  private resolveConflict(key: string, error: ConflictError) {
    // Last-write-wins, vector clocks, or custom resolution
    const local = this.localState.get(key);
    const remote = error.remoteValue;
    
    // Resolve based on timestamp or business rules
    if (local.timestamp > remote.timestamp) {
      this.remoteStore.update(key, local);
    } else {
      this.localState.set(key, remote);
    }
  }
}
```

**Materialized Views (CQRS Read Models):**
```typescript
class MaterializedView {
  private cache: Map<string, any> = new Map();
  private lastUpdate: Date = new Date(0);
  
  async refresh() {
    // Rebuild view from events
    const events = await this.eventStore.getEventsSince(this.lastUpdate);
    
    for (const event of events) {
      this.applyEvent(event);
    }
    
    this.lastUpdate = new Date();
  }
  
  private applyEvent(event: Event) {
    switch (event.type) {
      case 'OrderCreated':
        this.updateOrderView(event.data);
        break;
      case 'OrderUpdated':
        this.updateOrderView(event.data);
        break;
      // ... other events
    }
  }
  
  getView(key: string) {
    return this.cache.get(key);
  }
}
```
