final class Task9Y2024: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        let blocks = makeBlocks()

        let fragmented = fragment(blocks: blocks)

        let checksum = calculateChecksum(fragmentedBlocks: fragmented)

        return checksum
    }

    func solveB() -> Int {
        let blocks2 = makeBlocks2()

        let fragmented2 = fragment2(blocks: blocks2)

        let checksum = calculateChecksum2(fragmentedBlocks: fragmented2)

        return checksum
    }
}

private extension Task9Y2024 {
    func makeBlocks() -> [Block] {
        var id = 0
        var isFile = true
        var blocks: [Block] = []

        var formattedData = data[0]

        while !formattedData.isEmpty {
            let block = formattedData.removeFirst()

            for _ in 0 ..< Int(String(block))! {
                if isFile {
                    blocks.append(.init(value: id))
                } else {
                    blocks.append(.init(value: nil))
                }
            }

            if isFile {
                id += 1
            }

            isFile.toggle()
        }

        return blocks
    }
    
    func makeBlocks2() -> [Block2] {
        var id = 0
        var isFile = true
        var blocks: [Block2] = []

        var formattedData = data[0]

        while !formattedData.isEmpty {
            let block = formattedData.removeFirst()

            let size = Int(String(block))!
            blocks.append(.init(size: size, value: isFile ? id : nil))

            if isFile {
                id += 1
            }

            isFile.toggle()
        }

        return blocks.filter { $0.size != 0 }
    }
    
    private func fragment(blocks: [Block]) -> [Block] {
        var blocks = blocks

        let freeBlocks = blocks.enumerated().filter { $0.element.value == nil }.map(\.offset)
        
        for freeBlock in freeBlocks {
            if let fileBlock = blocks.lastIndex(where: { $0.value != nil }) {
                if freeBlock > fileBlock {
                    break
                }
                
                blocks.insert(blocks[fileBlock], at: freeBlock)
                blocks.remove(at: freeBlock.advanced(by: 1))
                blocks.remove(at: fileBlock)
            }
        }

        return blocks
    }
    
    private func fragment2(blocks: [Block2]) -> [Block2] {
        var resultBlocks = blocks

        var flag = true

        while flag {
            flag = false

            for (blockIndex, block) in resultBlocks.enumerated().reversed() where block.isFile {
                
                guard
                    let freeBlockIndex = resultBlocks.firstIndex(where: { !$0.isFile && $0.size >= block.size }),
                    freeBlockIndex > blockIndex
                else {
                    continue
                }

                let newBlocks = splitBlock(block: resultBlocks[freeBlockIndex], with: block)

                resultBlocks.insert(contentsOf: newBlocks, at: freeBlockIndex)
                resultBlocks.remove(at: freeBlockIndex.advanced(by: newBlocks.count))

                resultBlocks.insert(freeBlock(block: block), at: blockIndex.advanced(by: newBlocks.count - 1))
                resultBlocks.remove(at: blockIndex.advanced(by: newBlocks.count))

                flag = true
                break
            }
        }

        return resultBlocks
    }

    private func calculateChecksum(fragmentedBlocks: [Block]) -> Int {
        fragmentedBlocks.filter { $0.value != nil }.enumerated().reduce(0,  {
            if let value = $1.element.value {
                $0 + ($1.offset * value)
            } else {
                $0
            }
        })
    }

    private func calculateChecksum2(fragmentedBlocks: [Block2]) -> Int {
        var result = 0
        var offset = 0

        for fragmentedBlock in fragmentedBlocks {
            for _ in 0 ..< fragmentedBlock.size {
                if let value = fragmentedBlock.value {
                    result += offset * value
                }
                offset += 1
            }
        }

        return result
    }

    private func splitBlock(block: Block2, with originBlock: Block2) -> [Block2] {
        if block.size > originBlock.size {
            return [
                .init(size: originBlock.size, value: originBlock.value),
                .init(size: block.size - originBlock.size, value: nil),
            ]
        } else if block.size == originBlock.size {
            return [
                .init(size: originBlock.size, value: originBlock.value)
            ]
        } else {
            return []
        }
    }

    private func freeBlock(block: Block2) -> Block2 {
        .init(size: block.size, value: nil)
    }

    struct Block {
        let value: Int?
    }

    struct Block2 {
        let size: Int
        let value: Int?

        var isFile: Bool {
            value != nil
        }
    }
}
