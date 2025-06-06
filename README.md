# 以太坊红包智能合约

这是一个基于以太坊的红包智能合约项目，允许用户创建和领取红包。

## 功能

- 创建红包：用户可以创建指定金额和份数的红包
- 领取红包：其他用户可以领取红包，金额均分
- 查看红包列表：显示所有已创建的红包及其状态

## 技术栈

- Solidity ^0.8.13
- Truffle
- Ganache (本地开发网络)

## 合约结构

主要合约 `RedPacket.sol` 包含以下功能：

- `createPacket`: 创建新红包
- `claimPacket`: 领取红包
- `getPackets`: 获取红包列表
- `getBalance`: 查询合约余额

## 开发设置

1. 安装依赖
```bash
npm install
```

2. 启动本地区块链 (Ganache)

3. 编译合约
```bash
truffle compile
```

4. 部署合约
```bash
truffle migrate
```

5. 测试合约
```bash
truffle test
```

## 许可证

MIT 