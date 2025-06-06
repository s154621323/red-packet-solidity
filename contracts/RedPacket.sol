// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract RedPacket {
    // 红包映射
    mapping(uint256 => Packet) public packets;
    // 红包领取情况映射
    mapping(uint256 => mapping(address => bool)) public packetClaims;
    // 红包ID
    uint256 public packetId;
    // 红包
    struct Packet {
        address creator; // 红包创建者
        uint256 amount; // 红包金额
        uint256 count; // 剩余份数
        uint256 total; // 总份数
    }
    // 定义一个用于返回的红包信息结构体
    struct PacketInfo {
        address creator;
        uint256 amount;
        uint256 count;
        uint256 total;
        uint256 id;
    }

    // 查询账户余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 发红包
    function createPacket(uint256 amount, uint256 count) public payable {
        require(amount > 0, "Amount must be greater than 0");
        require(count > 0, "Count must be greater than 0");
        require(msg.value == amount, "Amount must be equal to msg.value");

        // 创建新红包
        Packet storage newPacket = packets[packetId];
        newPacket.creator = msg.sender;
        newPacket.amount = amount;
        newPacket.count = count;
        newPacket.total = count;

        packetId++;
    }

    // 领红包
    function claimPacket(uint256 _packetId) public {
        // 获取红包信息
        Packet storage packet = packets[_packetId];

        require(
            packet.creator != address(0) &&
                !packetClaims[_packetId][msg.sender] &&
                packet.count > 0 &&
                packet.amount > 0,
            "Invalid claim"
        );

        // 计算领取金额（简单平均分配）
        uint256 claimAmount = packet.count == 1
            ? packet.amount
            : packet.amount / packet.count;

        // 更新红包状态
        packet.count--;
        packet.amount -= claimAmount;

        // 标记为已领取
        packetClaims[_packetId][msg.sender] = true;

        // 转账给领取者
        payable(msg.sender).transfer(claimAmount);
    }

    // 获取红包列表
    function getPackets() public view returns (PacketInfo[] memory) {
        // 创建一个与红包数量相同大小的数组
        PacketInfo[] memory result = new PacketInfo[](packetId);

        // 遍历所有红包并填充信息
        for (uint256 i = 0; i < packetId; i++) {
            Packet storage packet = packets[i];

            // 只返回有效的红包（创建者不为零地址）
            if (packet.creator != address(0)) {
                result[i] = PacketInfo({
                    creator: packet.creator,
                    amount: packet.amount,
                    count: packet.count,
                    total: packet.total,
                    id: i
                });
            }
        }

        return result;
    }
}
