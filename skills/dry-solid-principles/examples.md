# DRY and SOLID Examples

Concrete examples of violations and their fixes.

## DRY Examples

### Example 1: Duplicated Validation

**Violation:**
```typescript
// controllers/users/requests/post.ts
export class PostUserRequests {
  async create(req: Request, res: Response) {
    const { email, password } = req.body;
    if (!email || !email.includes('@')) {
      return res.status(400).json({ error: 'Invalid email' });
    }
    if (!password || password.length < 8) {
      return res.status(400).json({ error: 'Password too short' });
    }
    // ...
  }
}

// controllers/users/requests/put.ts
export class PutUserRequests {
  async update(req: Request, res: Response) {
    const { email, password } = req.body;
    if (!email || !email.includes('@')) {
      return res.status(400).json({ error: 'Invalid email' });
    }
    if (!password || password.length < 8) {
      return res.status(400).json({ error: 'Password too short' });
    }
    // ...
  }
}
```

**Fix:**
```typescript
// utils/validators.ts
export function validateEmail(email: string): void {
  if (!email || !email.includes('@')) {
    throw new ValidationError('Invalid email');
  }
}

export function validatePassword(password: string): void {
  if (!password || password.length < 8) {
    throw new ValidationError('Password too short');
  }
}

// controllers/users/requests/post.ts
import { validateEmail, validatePassword } from '../../../utils/validators';

export class PostUserRequests {
  async create(req: Request, res: Response) {
    try {
      const { email, password } = req.body;
      validateEmail(email);
      validatePassword(password);
      // ...
    } catch (error) {
      if (error instanceof ValidationError) {
        return res.status(400).json({ error: error.message });
      }
      throw error;
    }
  }
}
```

### Example 2: Repeated Database Queries

**Violation:**
```typescript
// services/OrderService.ts
async function getOrderWithItems(orderId: number) {
  const order = await Order.findById(orderId);
  const items = await OrderItem.findAll({ where: { orderId } });
  return { ...order, items };
}

// services/OrderPriceService.ts
async function calculatePrice(orderId: number) {
  const order = await Order.findById(orderId);
  const items = await OrderItem.findAll({ where: { orderId } });
  // calculate using order and items
}
```

**Fix:**
```typescript
// repositories/OrderRepository.ts
async function findOrderWithItems(orderId: number) {
  const order = await Order.findById(orderId);
  const items = await OrderItem.findAll({ where: { orderId } });
  return { order, items };
}

// services/OrderService.ts
async function getOrderWithItems(orderId: number) {
  const { order, items } = await this.orderRepository.findOrderWithItems(orderId);
  return { ...order, items };
}

// services/OrderPriceService.ts
async function calculatePrice(orderId: number) {
  const { order, items } = await this.orderRepository.findOrderWithItems(orderId);
  // calculate using order and items
}
```

## SOLID Examples

### Example 1: Single Responsibility Violation

**Violation:**
```typescript
class OrderController {
  async createOrder(req: Request, res: Response) {
    // Validation
    if (!req.body.storeId) {
      return res.status(400).json({ error: 'Store ID required' });
    }
    
    // Business logic
    const order = await Order.create({
      storeId: req.body.storeId,
      userId: req.user.id,
      status: 'pending'
    });
    
    // Database operations
    await order.save();
    
    // Email notification
    await emailService.send({
      to: req.user.email,
      subject: 'Order Created',
      body: `Your order #${order.id} has been created`
    });
    
    // Response formatting
    return res.status(201).json({
      success: true,
      data: {
        id: order.id,
        status: order.status,
        createdAt: order.createdAt
      }
    });
  }
}
```

**Fix:**
```typescript
// controllers/orders/requests/post.ts
export class PostOrderRequests extends BaseController {
  constructor(
    private orderService: OrderService,
    private orderValidator: OrderValidator
  ) {
    super();
  }

  async create(req: Request, res: Response) {
    try {
      await this.orderValidator.validateCreate(req.body);
      const order = await this.orderService.createOrder({
        ...req.body,
        userId: req.user.id
      });
      return this.success(res, order, 201);
    } catch (error) {
      return this.error(res, error);
    }
  }
}

// services/OrderService.ts
export class OrderService {
  constructor(
    private orderRepository: OrderRepository,
    private notificationService: NotificationService
  ) {}

  async createOrder(data: CreateOrderData): Promise<Order> {
    const order = await this.orderRepository.create({
      storeId: data.storeId,
      userId: data.userId,
      status: 'pending'
    });
    
    await this.notificationService.notifyOrderCreated(order);
    return order;
  }
}
```

### Example 2: Dependency Inversion Violation

**Violation:**
```typescript
class OrderService {
  private db: MySQLDatabase;
  
  constructor() {
    this.db = new MySQLDatabase(); // concrete dependency
  }
  
  async getOrder(id: number) {
    return await this.db.query('SELECT * FROM orders WHERE id = ?', [id]);
  }
}

class EmailService {
  private transporter: SMTPTransporter;
  
  constructor() {
    this.transporter = new SMTPTransporter(); // concrete dependency
  }
  
  async sendEmail(data: EmailData) {
    return await this.transporter.send(data);
  }
}
```

**Fix:**
```typescript
// Define abstractions
interface Database {
  query(sql: string, params: any[]): Promise<any>;
}

interface EmailTransporter {
  send(data: EmailData): Promise<void>;
}

// Services depend on abstractions
class OrderService {
  constructor(private db: Database) {} // depends on interface
  
  async getOrder(id: number) {
    return await this.db.query('SELECT * FROM orders WHERE id = ?', [id]);
  }
}

class EmailService {
  constructor(private transporter: EmailTransporter) {} // depends on interface
  
  async sendEmail(data: EmailData) {
    return await this.transporter.send(data);
  }
}

// Dependency injection at composition root
const db = new MySQLDatabase();
const transporter = new SMTPTransporter();
const orderService = new OrderService(db);
const emailService = new EmailService(transporter);
```

### Example 3: Interface Segregation Violation

**Violation:**
```typescript
interface DataAccess {
  findById(id: number): Promise<any>;
  findAll(): Promise<any[]>;
  create(data: any): Promise<any>;
  update(id: number, data: any): Promise<any>;
  delete(id: number): Promise<void>;
  sendEmail(data: EmailData): Promise<void>; // unrelated method
  uploadFile(file: File): Promise<string>; // unrelated method
}

class UserRepository implements DataAccess {
  // Must implement all methods, even unused ones
  async sendEmail() { throw new Error('Not implemented'); }
  async uploadFile() { throw new Error('Not implemented'); }
}
```

**Fix:**
```typescript
// Segregated interfaces
interface Repository<T> {
  findById(id: number): Promise<T>;
  findAll(): Promise<T[]>;
  create(data: Partial<T>): Promise<T>;
  update(id: number, data: Partial<T>): Promise<T>;
  delete(id: number): Promise<void>;
}

interface EmailService {
  sendEmail(data: EmailData): Promise<void>;
}

interface FileService {
  uploadFile(file: File): Promise<string>;
}

// Classes implement only what they need
class UserRepository implements Repository<User> {
  // Only repository methods
}

class EmailNotificationService implements EmailService {
  // Only email methods
}
```

### Example 4: Open/Closed Principle Violation

**Violation:**
```typescript
class OrderProcessor {
  processOrder(order: Order) {
    if (order.type === 'standard') {
      // standard processing
    } else if (order.type === 'express') {
      // express processing
    } else if (order.type === 'premium') {
      // premium processing
    }
    // Must modify this class to add new order types
  }
}
```

**Fix:**
```typescript
// Abstract base class
abstract class OrderProcessor {
  abstract process(order: Order): Promise<void>;
}

// Concrete implementations
class StandardOrderProcessor extends OrderProcessor {
  async process(order: Order) {
    // standard processing logic
  }
}

class ExpressOrderProcessor extends OrderProcessor {
  async process(order: Order) {
    // express processing logic
  }
}

// Factory or strategy pattern
class OrderProcessorFactory {
  getProcessor(type: string): OrderProcessor {
    switch (type) {
      case 'standard': return new StandardOrderProcessor();
      case 'express': return new ExpressOrderProcessor();
      case 'premium': return new PremiumOrderProcessor();
      default: throw new Error('Unknown order type');
    }
  }
}

// Usage - can add new types without modifying existing code
const processor = factory.getProcessor(order.type);
await processor.process(order);
```
